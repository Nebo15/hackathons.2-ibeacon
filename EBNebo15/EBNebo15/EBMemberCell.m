//
//  EBMemberCell.m
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import "EBMemberCell.h"
#import "EBMember.h"
#import "NSDate+Converter.h"
#import <FacebookSDK/FBProfilePictureView.h>
@import CoreLocation;

@interface EBMemberCell()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *memberAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;

@end

@implementation EBMemberCell

+ (UINib*)nib
{
    return [UINib nibWithNibName:@"EBMemberCell" bundle:nil];
}

- (void)configureCellWithMember:(EBMember*)member
{
    _memberAvatarView.profileID = member.facebookID;
    _memberAvatarView.layer.cornerRadius = 23.0;
    _memberNameLabel.text = member.name;
    _updateDateLabel.text = [NSDate dayAndTimeWithDate:member.date];
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(290,15,10,10)];
    circleView.layer.cornerRadius = 5;
    circleView.backgroundColor = member.statusID == CLRegionStateInside?[UIColor greenColor]:[UIColor redColor];
    [self addSubview:circleView];
    
    self.contentView.alpha = member.statusID == CLRegionStateInside?1.0:0.5;
}

@end
