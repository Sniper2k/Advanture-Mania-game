//
//  Deck.h
//  AdvantureMania
//
//  Created by Owner Owner on 30.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DECK_SIZE       16

@interface Deck : NSObject
@property (retain) NSArray* m_cards;
@property (retain) NSString* m_name;
-(Deck*) initWithArray:(NSArray*) array Name:(NSString*) name;

-(Deck*) initWithDictionary:(NSDictionary*) dictionary;
-(NSDictionary*) toDictionary;
@end
