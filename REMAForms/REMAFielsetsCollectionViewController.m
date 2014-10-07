//
//  REMAFielsetsCollectionViewController.m
//  REMAForms
//
//  Created by Elvis Nunez on 03/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "REMAFielsetsCollectionViewController.h"

#import "REMAFieldsetHeaderView.h"
#import "REMABaseFieldCollectionCell.h"
#import "REMAFielsetBackgroundView.h"
#import "REMAFielsetsLayout.h"
#import "REMAFielsetsCollectionViewDataSource.h"

#import "REMATextFieldCollectionCell.h"
#import "REMADropdownFieldCollectionCell.h"
#import "REMADateFieldCollectionCell.h"

#import "REMAFieldset.h"
#import "REMAFormField.h"

#import "UIColor+ANDYHex.h"
#import "UIScreen+HYPLiveBounds.h"

@interface REMAFielsetsCollectionViewController () <REMAFieldsetHeaderViewDelegate>

@property (nonatomic, strong) REMAFielsetsCollectionViewDataSource *dataSource;

@end

@implementation REMAFielsetsCollectionViewController

#pragma mark - Initialization

- (instancetype)initWithCollectionViewLayout:(REMAFielsetsLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    layout.dataSource = self.dataSource;
    self.collectionView.dataSource = self.dataSource;

    return self;
}

#pragma mark - Delegate

- (REMAFielsetsCollectionViewDataSource *)dataSource
{
    if (_dataSource) return _dataSource;

    _dataSource = [[REMAFielsetsCollectionViewDataSource alloc] init];

    _dataSource.configureCellBlock = ^(REMABaseFieldCollectionCell *cell,
                                       NSIndexPath *indexPath,
                                       REMAFormField *field) {
        cell.field = field;

        if (field.sectionSeparator) {
            cell.backgroundColor = [UIColor colorFromHex:@"C6C6C6"];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    };

    __weak id weakSelf = self;
    _dataSource.configureHeaderViewBlock = ^(REMAFieldsetHeaderView *headerView,
                                             NSString *kind,
                                             NSIndexPath *indexPath,
                                             REMAFieldset *fieldset) {
        headerView.headerLabel.text = fieldset.title;
        headerView.delegate = weakSelf;
    };

    return _dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    self.collectionView.backgroundColor = [UIColor colorFromHex:@"DAE2EA"];

    [self.collectionView registerClass:[REMATextFieldCollectionCell class]
            forCellWithReuseIdentifier:REMATextFieldCellIdentifier];

    [self.collectionView registerClass:[REMADropdownFieldCollectionCell class]
            forCellWithReuseIdentifier:REMADropdownFieldCellIdentifier];

    [self.collectionView registerClass:[REMADateFieldCollectionCell class]
            forCellWithReuseIdentifier:REMADateFieldCellIdentifier];

    [self.collectionView registerClass:[REMAFieldsetHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:REMAFieldsetHeaderReuseIdentifier];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
    return CGSizeMake(CGRectGetWidth(bounds), REMAFieldsetHeaderHeight);
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - REMAFieldsetHeaderViewDelegate

- (void)fieldsetHeaderViewWasPressed:(REMAFieldsetHeaderView *)headerView
{
    [self.dataSource collapseFieldsInSection:headerView.section collectionView:self.collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

@end
