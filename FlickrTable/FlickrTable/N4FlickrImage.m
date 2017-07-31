//
//  N4FlickrImage.m
//  FlickrTable
//
//  Created by Diligent Worker on 7/29/13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImage.h"

#import "N4FlickrConstants.h"

@implementation N4FlickrImage

- (id)initWithTitle:(NSString*)title url:(NSString*)url previewURL:(NSString*)previewURL
{
    _title = title != nil ? title : @"";
    _url = url != nil ? url: @"";
    _previewURL = previewURL != nil? previewURL : @"";
    _comment = @"";
    return self;
}

- (id)initWithAttributes:(NSDictionary*)attributes
{
    if (attributes[N4FlickrImageDictionaryConstantTitle] && [attributes[N4FlickrImageDictionaryConstantTitle] isKindOfClass:[NSString class]] ) {
          _title = attributes[N4FlickrImageDictionaryConstantTitle];
    } else {
        _title = @"";
    }
    
    if (attributes[N4FlickrImageDictionaryConstantUrl ] && [attributes[N4FlickrImageDictionaryConstantUrl] isKindOfClass:[NSString class]] ) {
        _url = attributes[N4FlickrImageDictionaryConstantUrl ];
    } else {
        _url = @"";
    }
    
    if (attributes[N4FlickrImageDictionaryConstantPreviewUrl] && [attributes[N4FlickrImageDictionaryConstantPreviewUrl] isKindOfClass:[NSString class]] ) {
        _previewURL =  attributes[N4FlickrImageDictionaryConstantPreviewUrl];
    } else {
        _previewURL = @"";
    }
    
    if (attributes[N4FlickrImageDictionaryConstantComment] && [attributes[N4FlickrImageDictionaryConstantComment] isKindOfClass:[NSString class]] ) {
       _comment = attributes[N4FlickrImageDictionaryConstantComment];
    } else {
        _comment = @"";
    }

    return self;
}

@end
