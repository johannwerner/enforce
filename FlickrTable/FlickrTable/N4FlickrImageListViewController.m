//
//  N4FlickrImageListViewController.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImageListViewController.h"

#import "N4FlickrConstants.h"
#import "N4FlickerImageSource.h"
#import "N4FlickrImageCell.h"
#import "N4FlickrImageViewController.h"
#import "N4FlickrImage.h"

@interface N4FlickerImageCacheInfo : NSData
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) UIImage *image;

@end

@implementation N4FlickerImageCacheInfo
@end

@interface N4FlickrImageListViewController ()

@property (nonatomic, strong) N4FlickerImageSource *imageSource;

@property (nonatomic, strong)  NSMutableArray *imageCache;

@property (nonatomic, strong) NSOperationQueue *previewQueue;

@end

@implementation N4FlickrImageListViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Recent Photos";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 75.0f;
    [self.tableView registerClass:[N4FlickrImageCell class]
        forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];

    self.imageCache = [NSMutableArray new];
    self.imageSource = [N4FlickerImageSource new];
    self.previewQueue = [NSOperationQueue new];

    [self updatePhotos:nil];
}

- (void)updatePhotos:(id)sender
{
//#warning this indicator view is not visible :(
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    activityView.hidesWhenStopped = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];

    [activityView startAnimating];
    [self.imageSource fetchRecentImagesWithCompletion:^(NSArray *response, NSError *error) {
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updatePhotos:)];
    }];
}

#pragma mark - UITableView DataSource/Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView
	cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	N4FlickrImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
        NSStringFromClass([N4FlickrImageCell class])];
    N4FlickrImage *flickrImage = [_imageSource imageAtIndex:indexPath.row];
    
    cell.title = flickrImage.title;

    N4FlickerImageCacheInfo *found;

    // search our cache if we already downloaded this image
    for( N4FlickerImageCacheInfo *info in _imageCache )
        if([info.url isEqualToString:flickrImage.previewURL])
            found = info;

    if(found)
    {
        // we already downloaded this image, we can use it now
        cell.previewImage = found.image;
    }
    else
    {
        // we have not downloaded this image, download it now and add to cache
        found = [N4FlickerImageCacheInfo new];
        found.url = flickrImage.previewURL;
        [_imageCache addObject:found];

        dispatch_block_t block = ^
        {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:flickrImage.previewURL]];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

            NSURLResponse *response;

            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

            found.image = [UIImage imageWithData:responseData];

            cell.previewImage = found.image;
        };

        [_previewQueue addOperationWithBlock:block];
    }

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _imageSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show the selected image in our image view controller

        N4FlickrImageViewController *ctrl = [[N4FlickrImageViewController alloc]
                                             initWithFlickrImage:[_imageSource imageAtIndex:indexPath.row]];
        [self.navigationController pushViewController:ctrl animated:YES];
}
@end
