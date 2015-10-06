//
//  RPHTTPSessionManager.h
//  Dealabs
//
//  Created by Raphaël Pinto on 29/09/2015.
//  Copyright © 2015 HUME Network. All rights reserved.
//



#import "AFNetworking.h"
#import <Foundation/Foundation.h>



@interface RPHTTPSessionManager : AFHTTPSessionManager



@property (strong, nonatomic) NSMutableArray* operationManagerDelegates;



#pragma mark - Singleton Methods
+ (RPHTTPSessionManager*)sharedInstance;



#pragma mark - Static Methods
+ (void)cancelRequestWithMethod:(NSString*)_Method url:(NSString*)_URL;



@end
