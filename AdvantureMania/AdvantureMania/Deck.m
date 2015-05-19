//
//  Deck.m
//  AdvantureMania
//
//  Created by Owner Owner on 30.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "Deck.h"

@implementation Deck
@synthesize
m_cards = m_cards,
m_name = m_name;

-(Deck*) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(Deck*) initWithArray:(NSArray *)array Name:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.m_cards = array;
        self.m_name = name;
    }
    return self;
}

-(Deck*) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) return nil;
    
    self.m_name = [dictionary objectForKey:@"name"];
    self.m_cards = [dictionary objectForKey:@"cards"];
    
    return self;
}

-(NSDictionary*) toDictionary
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:m_name,@"name",m_cards,@"cards", nil];
    return dict;
}

-(void) dealloc
{
    self.m_cards = nil;
    self.m_name = nil;
}

@end
