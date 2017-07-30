//
//  API.m
//  FlickrTable
//
//  Created by Johann Werner on 30.07.17.
//  Copyright © 2017 NumberFour AG. All rights reserved.
//

#import "API.h"
#import "N4FlickrImage.h"
#import "N4FlickrConstants.h"

@implementation API

+ (void)fetchRecentImagesWithCompletion:(void (^)(NSArray *response,
                                                  NSError *error))completion {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:FLICKR_PHOTOS_ENDPOINT, FLICKR_KEY];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                            defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response,
                                    NSError *error) {
                    if (data != nil) {
                    NSDictionary *responseDictionary =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
                 
                        if (response != nil) {
                            NSArray *jsonImages = responseDictionary[@"photos"][@"photo"];
                            
                            NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity: jsonImages.count];
                            
                            for( NSDictionary * image in jsonImages )
                            {
                                NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@", image[@"farm"], image[@"server"], image[@"id"], image[@"secret"] ];
                                
                                NSMutableString* imageURL = [[NSMutableString alloc] initWithString:url];
                                [imageURL appendString:@"_b.jpg"];
                                NSMutableString *previewURL = [[NSMutableString alloc] initWithString:url];
                                [previewURL appendString:@"_q.jpg"];
                                
                                N4FlickrImage * flickerImage = [[N4FlickrImage alloc] initWithTitle:image[@"title"] url:imageURL previewURL:previewURL];
                                [images addObject:flickerImage];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                completion(images, error);
                            });

                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, error);
                            });
                        }
       
                    
                    } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, error);
                            });
                    }
                }] resume];
}

+ (void)fetchImageFromUrl:(NSString *)urlString
                onDidLoad:(void (^)(UIImage *image))onImageDidLoad {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
                       NSURL *imageURL = [NSURL URLWithString:urlString];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       UIImage *image = [UIImage imageWithData:imageData];
                       dispatch_async(dispatch_get_main_queue(), ^(void) {
                           onImageDidLoad(image);
                       });
                   });
}

@end
