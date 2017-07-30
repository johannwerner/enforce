//
//  N4ImageCacheHelper.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "API.h"

#import "N4ImageCacheHelper.h"

@interface N4ImageCacheHelper ()

@property(strong, nonatomic) NSMutableDictionary *imageCache;

@end

@implementation N4ImageCacheHelper

- (id)init {
    self = [super init];
    if (self) {
        self.imageCache = [@{} mutableCopy];
    }
    return self;
}

- (void)fetchImageFromUrl:(NSString *)urlString
                onDidLoad:(void (^)(UIImage *image))onImageDidLoad {
    UIImage *imageFromCache = self.imageCache[urlString];
    if (imageFromCache) {
        onImageDidLoad(imageFromCache);
    } else {
        N4ImageCacheHelper* __weak weakSelf = self;
        [API fetchImageFromUrl:urlString
                     onDidLoad:^(UIImage *image) {
                         if (urlString) {
                             weakSelf.imageCache[urlString] = image;
                             onImageDidLoad(image);
                         } else {
                             onImageDidLoad(nil);
                         }
                     }];
    }
}

@end
