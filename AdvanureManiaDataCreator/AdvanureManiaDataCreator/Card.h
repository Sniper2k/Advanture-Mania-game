//
//  Card.h
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class CardSprite;
@interface Card : NSObject
@property (assign) int m_limit, m_encost, m_id;
@property (retain) NSArray* m_actions;
@property (retain) NSString* m_name;
-(Card*) init;
-(Card*) initWithPrimaryKey:(int) pk database:(sqlite3*) db;
-(Card*) initWithCard:(Card*) card;

-(void) saveToDatabase:(sqlite3*) db;
@end
