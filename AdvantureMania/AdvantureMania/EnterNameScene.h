//
//  EnterNameScene.h
//  AdvantureMania
//
//  Created by Owner Owner on 29.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@class CCTextField;
@interface EnterNameScene : CCScene
@property (retain) CCTextField* m_name;
+ (EnterNameScene *)scene;
- (id)init;

- (void) onNextButton:(id) sender;
@end
