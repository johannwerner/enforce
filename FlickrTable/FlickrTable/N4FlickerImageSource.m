//
//  N4FlickerImageSource.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickerImageSource.h"
#import "N4FlickrImage.h"
#import "API.h"

@implementation N4FlickerImageSource
{
    NSArray *_images;
}
    
- (void)fetchRecentImagesWithCompletion:(void (^)(void))completion {
    [API fetchRecentImagesWithCompletion:^(NSArray *response, NSError *error) {
        _images = response;
        completion();
    }];
}


- (NSUInteger)count
{
    return _images.count;
}

- (N4FlickrImage*)imageAtIndex:(NSUInteger)index
{
    if(index < _images.count )
        return _images[index];
    return nil;
}

@end
