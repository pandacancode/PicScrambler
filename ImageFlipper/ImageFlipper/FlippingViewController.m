//
//  FlippingViewController.m
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 19/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import "FlippingViewController.h"
#import "FlipperModel.h"
#import "UIImageView+WebCache.h"
#import "ImageObject.h"
#import "FlippingCollectionReusableView.h"

@interface FlippingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FlipperDelegate> {
 
    FlipperModel *flipper;
    NSArray *imageObjects;
    
    NSTimer *timer;
    
    ImageObject *randomObject;
    NSInteger imagesLoaded;
    
    BOOL wrongOneSelected;
}
@end

@implementation FlippingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imagesLoaded = 0;
    wrongOneSelected = FALSE;
    
    self.imageGridCollection.delegate = self;
    self.imageGridCollection.dataSource = self;
    
    flipper = [[FlipperModel alloc] initWithURLString:@"https://api.flickr.com/services/feeds/photos_public.gne" withParams:@{@"format":@"json"} withRequestMethod:GET];
    flipper.delegate = self;
    
    [flipper getFlickrPhotos];
    
    //Setting up timer with TimeInterval as 1 sec
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [self.timerLabel setHidden:YES];
    [self.directionLabel setHidden:YES];
    [self.playAgainBtn setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) startTimer {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.timerLabel setHidden:NO];
        self.timerLabel.text = [NSString stringWithFormat:@"%d",[self.timerLabel.text intValue]-1];
//        NSLog(@"Timer label - %@", self.timerLabel.text);
        
        if ([self.timerLabel.text isEqualToString:@"0"]) {
            
            [timer invalidate];
            [self.timerLabel setHidden:YES];
            [self.directionLabel setHidden:NO];
            
            [self flipBackImages];
        }
    });
}


/**
 This method first checks if all the objects in array were visited or not. If yes then next iteration starts otherwise new random object is asked for.
 */
-(void) getRandomAndShowRandom {
    
    int count = 0;
    for (ImageObject *obj in imageObjects) {
        if (obj.wasSelected) {
            count++;
        }
    }
    
    if (count == 9) {
        [self clearAllAndStartOver];
    }
    else {
        [flipper getRandomObject];
    }
}

-(void) clearAllAndStartOver {
    
    UIAlertController *sucessAlert = [UIAlertController alertControllerWithTitle:@"Congrats" message:@"You completed the challenge. Wish to continue?." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [flipper resetValues];
        [self resetValues];
        [self flipAndFinish];
    }];
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //Setting up timer with TimeInterval as 1 sec
        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
        [flipper resetValues];
        [self resetValues];
        [flipper getFlickrPhotos];
    }];
    
    [sucessAlert addAction:cancelAction];
    [sucessAlert addAction:reloadAction];
    
    [self presentViewController:sucessAlert animated:YES completion:nil];
}

-(void) resetValues {
    
    [self.directionLabel setHidden:YES];
    [self.timerLabel setHidden:YES];
    [self.timerLabel setText:@"16"];
    [self.randomImageView setImage:nil];
    imageObjects = nil;
    imagesLoaded = 0;
}

-(void) flipAndFinish {
    
    for (ImageObject *obj in imageObjects) {
        obj.isVisible = FALSE;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [self.imageGridCollection reloadData];
        [self.playAgainBtn setHidden:NO];
    });
}

-(void) flipBackImages {
    
    for (ImageObject *obj in imageObjects) {
        obj.isVisible = FALSE;
    }
    
    [self.imageGridCollection reloadData];
    [self.imageGridCollection performBatchUpdates:^{}
                                  completion:^(BOOL finished) {
                                      
                                      //NSLog(@"Reload ended");
                                      [self getRandomAndShowRandom];
                                  }];
}

- (IBAction)playAgainPressed:(UIButton *)sender {
    
    //Setting up timer with TimeInterval as 1 sec
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    
    [flipper getFlickrPhotos];
    [self.playAgainBtn setHidden:YES];
}

#pragma FlipperModel delegates
-(void) fetchedPhotosWithResponse:(id)response withError:(NSError *)error {
    
    if (!error) {
        
        //NSLog(@"Parsed Response - %@", response);
        imageObjects = [NSArray arrayWithArray:response];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.imageGridCollection reloadData];
        });
    }
    else {
        NSLog(@"Proper JSON not recieved - %@",[error description]);
        UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Damn you Flickr!!. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No,thanks!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [flipper resetValues];
            [self resetValues];
            [self flipAndFinish];
        }];
        UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"Reload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [flipper getFlickrPhotos];
        }];
        
        [failAlert addAction:cancelAction];
        [failAlert addAction:reloadAction];
        
        [self presentViewController:failAlert animated:YES completion:nil];
    }
}

-(void) receivedRandomObject:(ImageObject *)object {
    
    randomObject = object;
    
    [self.randomImageView sd_setImageWithURL:[NSURL URLWithString:object.imagePath] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.randomImageView.alpha = 0.0;
        [UIView transitionWithView:self.randomImageView
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.randomImageView setImage:image];
                            self.randomImageView.alpha = 1.0;
                        } completion:NULL];
    }];
}

#pragma UICollectionView delegates
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    UIImageView *randomImage = (UIImageView *)[cell viewWithTag:100];
    [randomImage setContentMode:UIViewContentModeScaleToFill];
    
    if (![[imageObjects objectAtIndex:indexPath.row] isVisible] && !wrongOneSelected) {
        
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
        [UIView transitionWithView:randomImage
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            randomImage.image = placeholderImage;
                        } completion:nil];
    }
    else if (wrongOneSelected) {
        
        UIImage *placeholderWrongImage = [UIImage imageNamed:@"placeholderwrong.png"];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
        
        [UIView transitionWithView:randomImage
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            randomImage.image = placeholderWrongImage;
                        } completion: ^(BOOL finished) {
                            [UIView transitionWithView:randomImage
                                              duration:0.25
                                               options:UIViewAnimationOptionTransitionCrossDissolve
                                            animations:^{
                                                randomImage.image = placeholderImage;
                                            } completion:nil];
                        }
         ];
    }
    else {
     
        [randomImage setShowActivityIndicatorView:YES];
        [randomImage sd_setImageWithURL:[NSURL URLWithString:[[imageObjects objectAtIndex:indexPath.row] imagePath]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (!error) {
                imagesLoaded++;
                randomImage.alpha = 0.0;
                [UIView transitionWithView:randomImage
                                  duration:0.25
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [randomImage setImage:image];
                                    randomImage.alpha = 1.0;
                                } completion:NULL];
            }
            if (imagesLoaded == 9) {
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
        }];
    }
    
    return cell;
}

-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        FlippingCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        reusableView = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
        FlippingCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        reusableView = footerview;
    }

    return reusableView;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == randomObject.imageIndex) {
        
        wrongOneSelected = FALSE;
        
        [[imageObjects objectAtIndex:indexPath.row] setIsVisible:TRUE];
        [[imageObjects objectAtIndex:indexPath.row] setWasSelected:TRUE];
        
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [collectionView performBatchUpdates:^{}
                                           completion:^(BOOL finished) {
                                               
                                               //NSLog(@"Image Flipped");
                                               [self getRandomAndShowRandom];
                                           }];
    }
    else {
        wrongOneSelected = TRUE;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(105.0, 105.0);
}

@end
