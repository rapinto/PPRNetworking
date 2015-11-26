//
//  PPRHTTPSessionManager.m
//
//
//  Created by Raphaël Pinto on 29/09/2015.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "PPRHTTPSessionManager.h"
#import "PPRHTTPManagerDelegate.h"


@implementation PPRHTTPSessionManager


static dispatch_once_t onceToken = 0;


#pragma mark - Singleton Methods


+ (PPRHTTPSessionManager*)sharedInstance
{
    static PPRHTTPSessionManager *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Object Life Cycle Methods


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _operationManagerDelegates = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - Data Management Methods


+ (void)cancelRequestWithMethod:(NSString*)_Method url:(NSString*)_URL
{
    PPRHTTPSessionManager* lSessionManager = [PPRHTTPSessionManager sharedInstance];
    
    [[lSessionManager session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks)
     {
         for (NSURLSessionTask* aTask in dataTasks)
         {
             if ([aTask.originalRequest.HTTPMethod isEqualToString:_Method] &&
                 [[aTask.originalRequest.URL absoluteString] isEqualToString:_URL])
             {
                 [aTask cancel];
             }
         }
    }];
}


#pragma mark - HTTP Operation Methods


#warning REWORK THIS WITH AF 3.0 METHOD
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block CFAbsoluteTime lTotalTime = CFAbsoluteTimeGetCurrent();
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error)
                {
                    lTotalTime = CFAbsoluteTimeGetCurrent() - lTotalTime;
                    
                    if (error)
                    {
                        BOOL lHandled = NO;
                        
                        for(id anObject in _operationManagerDelegates)
                        {
                            if ([anObject conformsToProtocol:@protocol(PPRHTTPManagerDelegate)])
                            {
                                lHandled = [anObject isHandledReequestDidFail:request
                                                                 httpResponse:(NSHTTPURLResponse*)response
                                                               responseObject:responseObject
                                                                        error:error
                                                             requestTotalTime:lTotalTime];
                            }
                        }
                        
                        if (failure)
                        {
                            if (lHandled)
                            {
#warning replace ERROR
                                NSError *lError = [NSError errorWithDomain:@"RPNetworkingErrorDomain"
                                                                      code:409
                                                                  userInfo:nil];
                                
                                
                                failure(dataTask, lError);
                            }
                            else
                            {
                                failure(dataTask, error);
                            }
                        }
                        
                        
                        if (failure)
                        {
                            failure(dataTask, error);
                        }
                    }
                    else
                    {
                        for(id anObject in _operationManagerDelegates)
                        {
                            if ([anObject conformsToProtocol:@protocol(PPRHTTPManagerDelegate)])
                            {
                                [anObject requestDidSucceed:request
                                               httpResponse:(NSHTTPURLResponse*)response
                                             responseObject:responseObject
                                           requestTotalTime:lTotalTime];
                            }
                        }
                        
                        if (success)
                        {
                            success(dataTask, responseObject);
                        }
                    }
                }];
    
    return dataTask;
}



@end
