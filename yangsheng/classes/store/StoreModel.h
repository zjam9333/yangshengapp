//
//  StoreModel.h
//  yangsheng
//
//  Created by Macx on 17/7/13.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreModel : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic,strong) NSDictionary* rawDictionary;

@property (nonatomic,strong) NSString* idd;
@property (nonatomic,strong) NSString* store_title;
@property (nonatomic,strong) NSString* store_author;
@property (nonatomic,strong) NSString* store_tel;
@property (nonatomic,strong) NSString* store_address;
@property (nonatomic,strong) NSString* thumb;
@property (nonatomic,strong) NSString* lng;
@property (nonatomic,strong) NSString* lat;
@property (nonatomic,strong) NSString* distance;


@end