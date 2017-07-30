//
//  FavouritesTableViewController.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "N4FavouritesTableViewController.h"
#import "N4FlickrImageCell.h"
#import "N4SaveFavouriteOntoDiskHelper.h"
#import "N4FlickrImage.h"
#import "N4ImageCacheHelper.h"
#import "N4FlickrConstants.h"

@interface N4FavouritesTableViewController ()

@property (strong, nonatomic) NSArray *favouritesArray;
@property(strong, nonatomic) N4ImageCacheHelper *imageCacheHelper;

@end

@implementation N4FavouritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = N4FlickrImageCellHeightConstant;
    [self.tableView registerClass:[N4FlickrImageCell class]
           forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];
    
    self.favouritesArray = [N4SaveFavouriteOntoDiskHelper getListOfFavourites];
    
    self.imageCacheHelper = [[N4ImageCacheHelper alloc] init];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favouritesArray.count;
}

#pragma mark - UITableView DataSource/Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    N4FlickrImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               NSStringFromClass([N4FlickrImageCell class])];
    N4FlickrImage *flickrImage = [[N4FlickrImage alloc] initWithAttributes:self.favouritesArray[indexPath.row]];
    
    cell.title = flickrImage.comment;
    
    cell.previewImage = nil;
    [self.imageCacheHelper fetchImageFromUrl:flickrImage.previewURL
                                   onDidLoad:^(UIImage *image) {
                                       if (image != nil) {
                                           cell.previewImage = image;
                                       } else {
                                           cell.previewImage = nil;
                                       }
                                   }];
    return cell;
}

@end
