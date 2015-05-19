//
//  SelectDeckScene.h
//  AdvantureMania
//
//  Created by Owner Owner on 14.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface SelectDeckScene : CCScene
@property (assign) BOOL m_deletion;
@property (assign) NSInteger m_selected;
@property (retain) NSMutableArray* m_buttons;
@property (retain) CCSprite* m_highlight;
@property (retain) CCButton* m_erase;
+ (SelectDeckScene *)sceneWithEnabledDeletion:(BOOL) deletion;
- (id)initWithEnabledDeletion:(BOOL) deletion;

- (void) buttonPressed:(id) sender;
- (void)onBackClicked:(id)sender;
- (void)onSelectClicked:(id)sender;
- (void)onEraseClicked:(id) sender;
- (void) setEraseButtonPosition;
@end
