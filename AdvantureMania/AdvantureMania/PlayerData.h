//
//  PlayerData.h
//  AdvantureMania
//
//  Created by Owner Owner on 31.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AMOUNT_OF_DECKS 6

@interface PlayerData : NSObject
@property (retain) NSString* m_name;
@property (retain) NSMutableArray* m_decks;
- (PlayerData*) init;
- (void) saveData;

@end
