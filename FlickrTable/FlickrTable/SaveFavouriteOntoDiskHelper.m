//
//  SaveFavouriteOntoDiskHelper.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "SaveFavouriteOntoDiskHelper.h"
#import "N4FlickrImage.h"
#import "N4FlickrConstants.h"

static NSString * ListOfFavouritesDefaultsKey = @"ListOfFavouritesDefaultsKey";

@implementation SaveFavouriteOntoDiskHelper

+(void)addFavourtiteImage:(N4FlickrImage*) n4flickrImage
//This should ideally be done by saving on a sql database especially if data becomes more complex
{
    NSMutableArray *favouritesArray = [[SaveFavouriteOntoDiskHelper getListOfFavourites] mutableCopy];
    
    if (favouritesArray == nil) {
        favouritesArray = [[NSMutableArray alloc] init];
    }

    for (NSDictionary* n4flickrImageDict in favouritesArray) {
        N4FlickrImage *n4flickrImageInArray = [[N4FlickrImage alloc] initWithAttributes:n4flickrImageDict];
        if ([n4flickrImageInArray.url isEqualToString:n4flickrImage.url]) {
            [favouritesArray removeObject:n4flickrImageDict];
        }
        
    }

    [favouritesArray addObject:@{N4FlickrImageDictionaryConsantTitle:n4flickrImage.title,N4FlickrImageDictionaryConsantUrl:n4flickrImage.url,N4FlickrImageDictionaryConsantPreviewUrl:n4flickrImage.previewURL,N4FlickrImageDictionaryConsantComment:n4flickrImage.comment}];
    
    [[NSUserDefaults standardUserDefaults] setObject:favouritesArray forKey:ListOfFavouritesDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray*)getListOfFavourites
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ListOfFavouritesDefaultsKey];
}


@end
