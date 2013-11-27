//
//  EBMemberCell.h
//  EBNebo15
//
//  Created by Evgen Bakumenko on 11/27/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBMember;

@interface EBMemberCell : UITableViewCell

+ (UINib*)nib;
- (void)configureCellWithMember:(EBMember*)member;

@end
