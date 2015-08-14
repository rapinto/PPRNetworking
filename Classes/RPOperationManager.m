//
//  RPOperationManager.m
//
//
//  Created by Raphaël Pinto on 06/08/2015.
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



#import "RPOperationManager.h"
#import "OAuth1OperationManager.h"
#import "RPRequestOperation.h"
#import "RPOperationManagerDelegate.h"



@implementation RPOperationManager



#pragma mark -
#pragma mark Object Life Cycle Methods



- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        _operationManagerDelegates = [[NSMutableArray alloc] init];
    }
    
    return self;
}



#pragma mark -
#pragma mark Data Management Methods



+ (void)cancelRequestWithMethod:(NSString*)_Method url:(NSString*)_URL
{
    for (NSOperation *anOperation in [RPOperationManager sharedInstance].operationQueue.operations)
    {
        if([anOperation isKindOfClass:[AFHTTPRequestOperation class]])
        {
            AFHTTPRequestOperation* requestOperation = (AFHTTPRequestOperation*)anOperation;
            
            if ([requestOperation.request.HTTPMethod isEqualToString:_Method] &&
                [[requestOperation.request.URL absoluteString] isEqualToString:_URL])
            {
                [anOperation cancel];
            }
        }
    }
}



#pragma mark -
#pragma mark HTTP Operation Methods



- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    RPRequestOperation *operation = [[RPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    __weak __typeof(self)weakSelf = self;
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         for(id anObject in _operationManagerDelegates)
         {
             if ([anObject conformsToProtocol:@protocol(RPOperationManagerDelegate)])
             {
                 [anObject operationManager:weakSelf
                        didSucceedOperation:(RPRequestOperation*)operation
                         withResponseObject:responseObject];
             }
         }
         
         if (success)
         {
             success(operation, operation.responseObject);
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError* error)
     {
         BOOL lHandled = NO;
         
         for(id anObject in _operationManagerDelegates)
         {
             if ([anObject conformsToProtocol:@protocol(RPOperationManagerDelegate)])
             {
                 lHandled = [anObject isHandledOperationManager:weakSelf
                                               didFailOperation:(RPRequestOperation*)operation
                                                      withError:error];
             }
         }
         
         if (failure)
         {
             if (lHandled)
             {
                 NSError *lError = [NSError errorWithDomain:@"RPNetworkingErrorDomain"
                                                      code:409
                                                  userInfo:nil];
                 
                 
                 failure(operation, lError);
             }
             else
             {
                 failure(operation, error);
             }
         }
     }];
    
    
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    
    return operation;
}



@end
