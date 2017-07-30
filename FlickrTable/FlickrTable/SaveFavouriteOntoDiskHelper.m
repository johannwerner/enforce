//
//  SaveFavouriteOntoDiskHelper.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "SaveFavouriteOntoDiskHelper.h"
#import "N4FlickrImage.h"

static NSString * ListOfFavouritesDefaultsKey = @"ListOfFavouritesDefaultsKey";

@implementation SaveFavouriteOntoDiskHelper

+(void)addFavourtiteImage:(N4FlickrImage*) n4flickrImage

{
    NSMutableArray *favouritesArray = [[SaveFavouriteOntoDiskHelper getListOfFavourites] mutableCopy];
    
    if (favouritesArray == nil) {
        favouritesArray = [[NSMutableArray alloc] init];
    }
    bool alreadySaved = false;
    for (N4FlickrImage* n4flickrImageInArray in favouritesArray) {
        if (n4flickrImage.url == n4flickrImageInArray.url && n4flickrImage.title == n4flickrImageInArray.title && n4flickrImage.url == n4flickrImageInArray.url && n4flickrImage.previewURL == n4flickrImageInArray.previewURL) {
            n4flickrImageInArray.comment = n4flickrImage.comment;
            alreadySaved = true;
        }
    }
    if (!alreadySaved) {
         NSData *imageEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:n4flickrImage];
            [favouritesArray addObject:imageEncodedObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:favouritesArray forKey:ListOfFavouritesDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(NSArray*)getListOfFavourites
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ListOfFavouritesDefaultsKey];
}


@end
