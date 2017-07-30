//
//  API.h
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (void)fetchRecentImagesWithCompletion:(void (^)(NSArray *response,
                                                  NSError *error))completion;

+ (void)fetchImageFromUrl:(NSString *)urlString
                onDidLoad:(void (^)(UIImage *image))onImageDidLoad;

@end
