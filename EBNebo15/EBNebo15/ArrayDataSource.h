//
//  ArrayDataSource.h
//  ECommpay
//
//  Created by Evgen Bakumenko on 10/1/13.
//  Copyright (c) 2013 Evgen Bakumenko. All rights reserved.
//

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end