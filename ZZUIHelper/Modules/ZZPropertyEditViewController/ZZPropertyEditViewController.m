//
//  ZZPropertyEditViewController.m
//  ZZUIHelper
//
//  Created by 李伯坤 on 2017/2/21.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZPropertyEditViewController.h"
#import "ZZPropertyEditViewController+Delegate.h"
#import "ZZUIScrollView.h"
#import "ZZUIControl.h"

@interface ZZPropertyEditViewController ()

@end

@implementation ZZPropertyEditViewController

- (void)loadView
{
    [super loadView];
    
    [self.collectionView setWantsLayer:YES];
    [self.collectionView.layer setBackgroundColor:[NSColor windowBackgroundColor].CGColor];
    
    [self registerViewsForCollectionView:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProperty:) name:NOTI_CLASS_PROPERTY_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProperty:) name:NOTI_CLASS_PROPERTY_SELECTED object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)editProperty:(NSNotification *)notification
{
    ZZNSObject *object = notification.object;
    
    // Events
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    if ([[object class] isSubclassOfClass:[ZZUIControl class]] && [(ZZUIControl *)object events].count > 0) {
        ZZPropertySectionModel *eventsMethods = [[ZZPropertySectionModel alloc] initWithSectionType:ZZPropertySectionTypeEvent title:@"Events" andData:[(ZZUIControl *)object events]];
        [mData addObject:eventsMethods];
    }
    
    // Delegates
    if ([[object class] isSubclassOfClass:[ZZUIScrollView class]] && [(ZZUIScrollView *)object delegates].count > 0) {
        for (ZZProtocol *protocol in [(ZZUIScrollView *)object delegates]) {
            ZZPropertySectionModel *protocolMethods = [[ZZPropertySectionModel alloc] initWithSectionType:ZZPropertySectionTypeDelegate title:protocol.protocolName andData:protocol.protocolMethods];
            [mData addObject:protocolMethods];
        }
    }
    
    self.object = object;
    self.data = mData;
    [self.collectionView reloadData];
}


@end
