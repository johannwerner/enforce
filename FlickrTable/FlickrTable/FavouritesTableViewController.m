//
//  FavouritesTableViewController.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "FavouritesTableViewController.h"
#import "N4FlickrImageCell.h"
#import "SaveFavouriteOntoDiskHelper.h"
#import "N4FlickrImage.h"
#import "ImageCacheHelper.h"

@interface FavouritesTableViewController ()

@property (strong, nonatomic) NSArray *favouritesArray;
@property(strong, nonatomic) ImageCacheHelper *imageCacheHelper;

@end

@implementation FavouritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.tableView.rowHeight = 75.0f;
    [self.tableView registerClass:[N4FlickrImageCell class]
           forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];
    
    self.favouritesArray = [SaveFavouriteOntoDiskHelper getListOfFavourites];
    
    self.imageCacheHelper = [[ImageCacheHelper alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    N4FlickrImage *flickrImage = [[N4FlickrImage alloc] initWithDictionary:self.favouritesArray[indexPath.row]];
    
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
