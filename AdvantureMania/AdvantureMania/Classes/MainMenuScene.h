//
//  IntroScene.h
//  AdvantureMania
//
//  Created by Owner Owner on 10.07.14.
//  Copyright Sniper 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface MainMenuScene : CCScene

// -----------------------------------------------------------------------

+ (MainMenuScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end