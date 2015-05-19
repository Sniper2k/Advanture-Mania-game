//
//  Data.h
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
@property NSArray* m_cards;

-(Data*) init;
-(void) loadCards;
@end
