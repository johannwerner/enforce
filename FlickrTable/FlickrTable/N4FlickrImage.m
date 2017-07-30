//
//  N4FlickrImage.m
//  FlickrTable
//
//  Created by Christian Lippka on 7/29/13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImage.h"

@implementation N4FlickrImage

- (id)initWithTitle:(NSString*)title url:(NSString*)url previewURL:(NSString*)previewURL imageId:(long)imageId
{
    _title = title;
    _url = url;
    _previewURL = previewURL;
    _imageId = imageId;
    _comment = @"";
    return self;
}


- (id)initWithDictionary:(NSDictionary*)dictionary
{
    _title = dictionary[@"title"];
    _url = dictionary[@"url"];
    _previewURL =  dictionary[@"previewUrl"];
    _comment = dictionary[@"comment"];
    return self;
}



@end
