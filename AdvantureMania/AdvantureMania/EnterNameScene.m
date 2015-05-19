//
//  EnterNameScene.m
//  AdvantureMania
//
//  Created by Owner Owner on 29.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "EnterNameScene.h"
#import "GlobalData.h"
#import "MainMenuScene.h"

const float ENS_FONT_SIZE           = 18.0f;

const float ENS_LABEL_X    = 284.0f/SCREEN_X;
const float ENS_LABEL_Y    = 250.0f/SCREEN_Y;

const float ENS_FIELD_X    = 284.0f/SCREEN_X;
const float ENS_FIELD_Y    = 150.0f/SCREEN_Y;

const float ENS_FIELD_CONTENT_X    = 50;
const float ENS_FIELD_CONTENT_Y    = 20;

const float ENS_BUTTON_X   = 284.0f/SCREEN_X;
const float ENS_BUTTON_Y   = 80.0f/SCREEN_Y;
@implementation EnterNameScene
@synthesize m_name = m_name;
+ (EnterNameScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // text label
    CCLabelTTF* text = [CCLabelTTF labelWithString:@"Welcome traveller!\n What's your name?" fontName:FONT_NAME fontSize:ENS_FONT_SIZE];
    text.positionType = CCPositionTypeNormalized;
    text.position = ccp(ENS_LABEL_X,ENS_LABEL_Y);
    text.color = [CCColor colorWithUIColor:[UIColor yellowColor]];
    [self addChild:text];
    
    // text field
    CCSprite *textSprite = [CCSprite spriteWithImageNamed:@"TextTile.png"];
    self.m_name = [CCTextField textFieldWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"TextTile.png"]];
    
    m_name.textField.font = [UIFont fontWithName:FONT_NAME size:ENS_FONT_SIZE];
    m_name.textField.textColor = [UIColor yellowColor];
    m_name.contentSize = CGSizeMake(ENS_FIELD_CONTENT_X, ENS_FIELD_CONTENT_Y);
    m_name.preferredSize = textSprite.contentSize;
    m_name.positionType = CCPositionTypeNormalized;
    m_name.position = ccp(ENS_FIELD_X, ENS_FIELD_Y);
    m_name.string = g_player.m_name;
    [self addChild:self.m_name];
    textSprite = nil;
    
    // next button
    CCButton* button = [CCButton buttonWithTitle:@"[ Next ]" fontName:FONT_NAME fontSize:ENS_FONT_SIZE];
    button.color = [CCColor colorWithUIColor:[UIColor yellowColor]];
    [button setTarget:self selector:@selector(onNextButton:)];
    button.positionType = CCPositionTypeNormalized;
    button.position = ccp(ENS_BUTTON_X,ENS_BUTTON_Y);
    [self addChild:button];
    
    return self;
}

-(void) dealloc
{
    self.m_name = nil;
}

-(void) onNextButton:(id)sender
{
    g_player.m_name = [m_name string];
    [g_player saveData];
    
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene] withTransition:[CCTransition transitionFadeWithDuration:1.0f]];
}
@end
