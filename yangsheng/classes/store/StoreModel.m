//
//  StoreModel.m
//  yangsheng
//
//  Created by Macx on 17/7/13.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        _rawDictionary=dictionary;
        
        _idd=[dictionary valueForKey:@"id"];
        _store_title=[dictionary valueForKey:@"store_title"];
        _store_author=[dictionary valueForKey:@"store_author"];
        _store_tel=[dictionary valueForKey:@"store_tel"];
        _store_address=[dictionary valueForKey:@"store_address"];
        _thumb=[dictionary valueForKey:@"thumb"];
        _lng=[dictionary valueForKey:@"lng"];
        _lat=[dictionary valueForKey:@"lat"];
        _distance=[dictionary valueForKey:@"distance"];
        
        _store_content=[dictionary valueForKey:@"store_content"];
        NSString* html=_store_content;
        if (![html containsString:@"<html>"]) {
            if (![html containsString:@"<body>"]) {
                html=[NSString stringWithFormat:@"<body>%@</body>",html];
            }
            html=[NSString stringWithFormat:@"<html>%@</html>",html];
        }
        NSString* js=@"<script>window.onload = function() {window.location.href = \"ready://\" + document.body.scrollHeight;}</script>";
        html=[NSString stringWithFormat:@"%@%@",html,js];
        _store_content=html;
    
        NSDictionary* smeta_json=[dictionary valueForKey:@"smeta_json"];
        NSArray* list=[smeta_json valueForKey:@"list"];
        NSMutableArray* urls=[NSMutableArray array];
        for (NSDictionary* u in list) {
            NSString* url=[u valueForKey:@"url"];
            if (url.length>0) {
                [urls addObject:url];
            }
        }
        _smetas=[NSArray arrayWithArray:urls];
        
        NSArray* items=[dictionary valueForKey:@"item"];
        NSMutableArray* its=[NSMutableArray array];
        for (NSDictionary* i in items) {
            StoreItem* item=[[StoreItem alloc]initWithDictionary:i];
            [its addObject:item];
        }
        _items=[NSArray arrayWithArray:its];
    }
    return self;
}

@end

@implementation StoreItem

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self.item_id=[dictionary valueForKey:@"item_id"];
        self.name=[dictionary valueForKey:@"name"];
        self.code=[dictionary valueForKey:@"code"];
        self.thumb=[dictionary valueForKey:@"thumb"];
    }
    return self;
}

@end

@implementation StoreApplyModel

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self.rawDictionary=dictionary;
        
        self.name=[dictionary valueForKey:@"name"];
        self.tel=[dictionary valueForKey:@"tel"];
        self.idcard=[dictionary valueForKey:@"idcard"];
        self.area=[dictionary valueForKey:@"area"];
        self.address=[dictionary valueForKey:@"address"];
        self.lng=[dictionary valueForKey:@"lng"];
        self.lat=[dictionary valueForKey:@"lat"];
//        NSInteger st=[[dictionary valueForKey:@"status"]integerValue];
//        if (st==0) {
//            self.status=@"未审核";
//        }
//        else if(st==1)
//        {
//            self.status=@"已审核";
//        }
//        else if(st==2)
//        {
//            self.status=@"审核驳回";
//        }
        
        self.status=[[dictionary valueForKey:@"status"]integerValue];
        
        self.info=[dictionary valueForKey:@"info"];
        NSDictionary* thumb=[dictionary valueForKey:@"thumb"];
        if ([thumb isKindOfClass:[NSDictionary class]]) {
            self.positive=[thumb valueForKey:@"positive"];
            self.negative=[thumb valueForKey:@"negative"];
        }
    }
    return self;
}

@end