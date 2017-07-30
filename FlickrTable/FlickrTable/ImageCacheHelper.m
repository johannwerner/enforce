//
//  ImageCacheHelper.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "API.h"
#import "ImageCacheHelper.h"

@interface ImageCacheHelper ()

@property(strong, nonatomic) NSMutableDictionary *imageCache;

@end

@implementation ImageCacheHelper

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
        [API fetchImageFromUrl:urlString
                     onDidLoad:^(UIImage *image) {
                         if (urlString) {
                             self.imageCache[urlString] = image;
                             onImageDidLoad(image);
                         } else {
                             onImageDidLoad(nil);
                         }
                     }];
    }
}

@end
