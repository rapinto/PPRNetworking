//
//  RPHTTPManagerDelegate.h
//  Dealabs
//
//  Created by Raphaël Pinto on 06/10/2015.
//  Copyright © 2015 HUME Network. All rights reserved.
//

#ifndef RPHTTPSessionManagerDelegate_h
#define RPHTTPSessionManagerDelegate_h



#import <Foundation/Foundation.h>



@protocol RPHTTPManagerDelegate <NSObject>


- (void)requestDidSucceed:(NSURLRequest*)request
             httpResponse:(NSHTTPURLResponse*)response
           responseObject:(id)responseObject
         requestTotalTime:(CFAbsoluteTime)totalTime;
- (BOOL)isHandledReequestDidFail:(NSURLRequest*)request
                    httpResponse:(NSHTTPURLResponse*)response
                  responseObject:(id)responseObject
                           error:(NSError*)error
                requestTotalTime:(CFAbsoluteTime)totalTime;


@end



#endif /* RPHTTPManagerDelegate_h */
