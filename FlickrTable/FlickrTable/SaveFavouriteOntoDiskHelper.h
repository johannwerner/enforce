//
//  SaveFavouriteOntoDiskHelper.h
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class N4FlickrImage;

@interface SaveFavouriteOntoDiskHelper : NSObject

+(void)addFavourtiteImage:(N4FlickrImage*) n4flickrImage;

+(NSArray*)getListOfFavourites;

@end
