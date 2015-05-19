//
//  CardSprite.h
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLabelTTF.h"

#define CS_MOVEBY_TIME   0.5f

@class CCSprite;
@class CCLabelTTF;
@class CCNode;
@class CCAction;

@interface Limit : CCLabelTTF
@property (assign) int m_limit;
@property (assign) int m_taken;
+(Limit*) labelWithLimit:(int) limit Taken:(int) taken Text:(NSString*) text Font:(NSString*) font FontSize:(CGFloat) fontSize;

-(void) changeTakenByValue:(int) value;
@end

@interface CardSprite : NSObject
@property (assign) int m_id;
@property (retain) CCSprite* m_background;
@property (retain) CCLabelTTF* m_name;
@property (retain) CCLabelTTF* m_encost;
@property (retain) NSArray* m_icons;
@property (retain) NSArray* m_values;
@property (assign) BOOL m_small;
@property (assign) BOOL m_highlighted;
@property (retain) Limit* m_limit;

-(CardSprite*) initWithId:(int) iid Position:(CGPoint) position Small:(BOOL) small Limit:(BOOL) limit Value:(int) value;
-(void) addParent:(CCNode*) node Zorder:(NSInteger) z;
-(void) removeParent:(CCNode*) node;
-(void) MoveBy:(CGPoint) delta;
-(void) stopAllActions;
-(CGPoint) position;
@end
