//
//  N4FlickrImage.m
//  FlickrTable
//
//  Created by Christian Lippka on 7/29/13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImage.h"
#import "N4FlickrConstants.h"

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

- (id)initWithAttributes:(NSDictionary*)attributes
{
    if (attributes[N4FlickrImageDictionaryConsantTitle] && [attributes[N4FlickrImageDictionaryConsantTitle] isKindOfClass:[NSString class]] ) {
          _title = attributes[N4FlickrImageDictionaryConsantTitle];
    }
    
    if (attributes[N4FlickrImageDictionaryConsantUrl ] && [attributes[N4FlickrImageDictionaryConsantUrl] isKindOfClass:[NSString class]] ) {
        _url = attributes[N4FlickrImageDictionaryConsantUrl ];
    }
    
    if (attributes[N4FlickrImageDictionaryConsantPreviewUrl] && [attributes[N4FlickrImageDictionaryConsantPreviewUrl] isKindOfClass:[NSString class]] ) {
        _previewURL =  attributes[N4FlickrImageDictionaryConsantPreviewUrl];
    }
    
    if (attributes[N4FlickrImageDictionaryConsantComment] && [attributes[N4FlickrImageDictionaryConsantComment] isKindOfClass:[NSString class]] ) {
       _comment = attributes[N4FlickrImageDictionaryConsantComment];
    }

    return self;
}



@end
