//
//  ViewController.m
//  TapAndSort
//
//  Created by Gin on 7/20/14.
//  Copyright (c) 2014 Nguyễn Huỳnh Lâm. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
{
    NSArray *photo,*photoOnScreen;
    SystemSoundID soundID,sortSound;
    __weak IBOutlet UIButton *trashButton;
    __weak IBOutlet UIButton *sortButton;
    UIImageView *aPhoto;
    int count;
    int w,h,k;
    float x,y,x1,x2,y1,y2;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	photo = [ [NSArray alloc] initWithObjects:
                [UIImage imageNamed:@"1.png"],
             [UIImage imageNamed:@"2.png"],
             [UIImage imageNamed:@"3.png"],
             [UIImage imageNamed:@"4.png"],
             [UIImage imageNamed:@"5.png"],
             [UIImage imageNamed:@"6.png"],
             [UIImage imageNamed:@"7.png"],
             [UIImage imageNamed:@"8.png"],nil];
    
    NSURL *soundX = [NSURL fileURLWithPath:[[NSBundle mainBundle]	pathForResource:@"trash" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef) soundX, 	&soundID);
    NSURL *soundY = [NSURL fileURLWithPath:[[NSBundle mainBundle]	pathForResource:@"sortSound" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef) soundY, 	&sortSound);

    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onTap:)];
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
              
    [self.view addGestureRecognizer: tapGesture];
}

- (void) onTap: (UITapGestureRecognizer*) tap
{
        CGPoint point = [tap locationInView:self.view];
    
        // NSLog(@"x=%f - y=%f", point.x, point.y);
    
    int index = rand() % 8;
    aPhoto = [[UIImageView alloc] initWithImage: [photo objectAtIndex: index]];
    
    aPhoto.center = point;
    [self.view addSubview:aPhoto];
    [self.view bringSubviewToFront: trashButton]; // cho ảnh đằng sau 1 ảnh #, ở đây là trash
    [self.view bringSubviewToFront: sortButton];
    [self makeItCool];

}

  
- (IBAction)sort:(id)sender {

    count = self.view.subviews.count - 4;
    
    w = 1;h = 2;k = 5;
    
    while(1)
    {
        if(count <= w*h)
            break;
        
        w++;
        h++;
    }
    
    x = (320 - (w+1)*k )/w;
    y = (480 - (h+1)*k )/h;
    
    x1 = k + x/2;
    y1 = 25 + k + y/2;
    x2 = x1 + k + x;
    y2 = y1;
    
    count = 1;
    AudioServicesPlaySystemSound(sortSound);

    for(UIView *view in self.view.subviews)
    {
        
        if ([view isMemberOfClass:[UIImageView class]])
        {
            
            [UIView animateWithDuration:1.0f
                             animations:^(void)
             {

                 if(count == 1)
                     view.center = CGPointMake(x1,y1);
                 else
                     view.center = CGPointMake(x2,y1);
                
                 
                 
                 CGAffineTransform transform = CGAffineTransformMakeScale(0.95*x/150,0.95* y/150); // 150 la size anh goc
                 view.transform = transform;


                 if(count == w)
                 {
                     count = 1;
                     x1 = k + x/2;
                     y1 = y1 + k + y;
                 }
                 else
                 {
                     x2 = x1 + k + x;
                     x1 = x2; // luu gia tri cu
                     
                     y2 = y1;
                     count++;
                 }

             }
                             completion:^(BOOL finished)
             {
               //  [view removeFromSuperview];
                 
             }];
        }
    }

}

- (IBAction)trash:(id)sender {
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[UIImageView class]])
        {
            AudioServicesPlaySystemSound(soundID);
            
            [UIView animateWithDuration:1.0f
                             animations:^(void)
             {
                 view.center = trashButton.center;
                 CGAffineTransform transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                 view.transform = transform;
                 view.alpha = 0.1f;
                 
             }
                             completion:^(BOOL finished)
             {
                 [view removeFromSuperview];
                 
             }];
        }    
    }
}
- (void) makeItCool
{
    [aPhoto.layer setMasksToBounds:NO];
    
    [aPhoto.layer setBorderWidth:5.0f];
    [aPhoto.layer setBorderColor:[[UIColor whiteColor] CGColor]]; // tạo viền ngoài cho ảnh màu trắng
    
    [aPhoto.layer setShadowRadius:5.0f];
    [aPhoto.layer setShadowOpacity:.85f]; // bóng đục bên ngoài để hiện border color
    [aPhoto.layer setShadowOffset:CGSizeMake(1.0f, 2.0f)];
    [aPhoto.layer setShadowColor:[[UIColor blackColor] CGColor]]; // màu của chế độ đổ bóng
    [aPhoto.layer setShouldRasterize:YES];
    [aPhoto.layer setMasksToBounds:NO];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(((float)rand()/RAND_MAX - 0.5)*0.4); // giao dong tu -0.1 --> 0.1
    
    aPhoto.transform = transform;
}

@end
