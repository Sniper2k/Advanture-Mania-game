//
//  DeckSprite.h
//  AdvantureMania
//
//  Created by Owner Owner on 20.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSprite;
@class CCButton;
@class CCLabelTTF;
@class CCNode;
@interface DeckSprite : NSObject
@property (retain) CCSprite* m_border;
@property (retain) CCButton* m_image;
@property (retain) CCLabelTTF* m_name;
@property (retain) CCSprite* m_disabled;

-(DeckSprite*) initWithID:(NSInteger) idd Position:(CGPoint) position ButtonAction:(SEL) selector Parent:(CCNode*) parent Deletion:(BOOL) deletion;
-(void) addParent:(CCNode*) node Zorder:(NSInteger) z;
-(void) removeParent:(CCNode*) node;
-(CGPoint) position;
@end
