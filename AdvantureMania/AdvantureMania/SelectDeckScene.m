//
//  SelectDeckScene.m
//  AdvantureMania
//
//  Created by Owner Owner on 14.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "SelectDeckScene.h"
#import "DeckSprite.h"
#import "GlobalData.h"
#import "MainMenuScene.h"
#import "DeckBuilderScene.h"

const int SD_BUTTONS_IN_LINE   =2;
const int SD_BUTTONS_IN_ROW    =3;
const int SD_BUTTONS_AMOUNT    =6;

const float SD_BUTTONS_START_X    = 100.0f/SCREEN_X;
const float SD_BUTTONS_START_Y    = 50.0f/SCREEN_Y;

const float SD_BUTTONS_STEP_X    = 200.0f/SCREEN_X;
const float SD_BUTTONS_STEP_Y    = 100.0f/SCREEN_Y;
const float SD_BUTTONS_Z           = 2;

const float SD_BACK_BUTTON_Z       = 3;
const float SD_HIGHLIGHT_Z         = 5;

const float SD_FONT_SIZE_NORMAL    = 18;

const float SD_CANCEL_BUTTON_X       = 75.0f/SCREEN_X;
const float SD_CANCEL_BUTTON_Y       = 25.0f/SCREEN_Y;
const float SD_CANCEL_BUTTON_Z       = SD_HIGHLIGHT_Z + 1;

@implementation SelectDeckScene
@synthesize
m_deletion = m_deletion,
m_buttons = m_buttons,
m_selected = m_selected,
m_highlight = m_highlight,
m_erase = m_erase;

+(SelectDeckScene*) sceneWithEnabledDeletion:(BOOL)deletion
{
    return [[self alloc] initWithEnabledDeletion:deletion];
}

-(id) initWithEnabledDeletion:(BOOL)deletion
{
    self = [super init];
    if (!self) return nil;
    
    self.m_deletion = deletion;
    
    self.m_selected = 0;
    self.m_highlight = [CCSprite spriteWithImageNamed:@"DeckHighlight.png"];
    m_highlight.positionType = CCPositionTypeNormalized;
    m_highlight.position = ccp(SD_BUTTONS_START_X, SD_BUTTONS_START_Y);
    [self addChild:m_highlight z:SD_HIGHLIGHT_Z];
    
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" fontName:FONT_NAME fontSize:SD_FONT_SIZE_NORMAL];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton z:SD_BACK_BUTTON_Z];
    
    CCButton *selectButton = [CCButton buttonWithTitle:@"Select" fontName:FONT_NAME fontSize:SD_FONT_SIZE_NORMAL];
    selectButton.positionType = CCPositionTypeNormalized;
    selectButton.position = ccp(0.85f, 0.05f); // Bottom Right of screen
    [selectButton setTarget:self selector:@selector(onSelectClicked:)];
    [self addChild:selectButton z:SD_BACK_BUTTON_Z];
    
    int i,j;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:SD_BUTTONS_AMOUNT];
    
    for (j =0;j<SD_BUTTONS_IN_ROW;j++)
    {
        for (i=0;i<SD_BUTTONS_IN_LINE;i++)
        {
            DeckSprite* sprite = [[DeckSprite alloc] initWithID:i + j*SD_BUTTONS_IN_LINE Position:ccp(SD_BUTTONS_START_X + i*SD_BUTTONS_STEP_X, SD_BUTTONS_START_Y + j*SD_BUTTONS_STEP_Y) ButtonAction:@selector(buttonPressed:) Parent:self Deletion:m_deletion];
            [sprite addParent:self Zorder:SD_BUTTONS_Z];
            [array addObject:sprite];
        }
    }
    
    self.m_buttons = array;
    array = nil;
    
    if (m_deletion)
    {
        self.m_erase = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"CancelButton.png"]];
        [m_erase setTarget:self selector:@selector(onEraseClicked:)];
        m_erase.positionType = CCPositionTypeNormalized;
        [self setEraseButtonPosition];
        [self addChild:self.m_erase z:SD_CANCEL_BUTTON_Z];
    }
    
    return self;
}

-(void) dealloc
{
    self.m_buttons = nil;
    self.m_erase = nil;
    self.m_highlight = nil;
}

- (void)onBackClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

-(void) buttonPressed:(id)sender
{
    NSInteger index = [m_buttons indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL* stop){
        DeckSprite *sprite = (DeckSprite*)obj;
        BOOL ret = (sprite.m_image == sender);
        return ret;
    }];
    
    m_selected = index;
    m_highlight.position = [(CCButton*)sender position];
    
    if (m_deletion)
        [self setEraseButtonPosition];
}

-(void) onSelectClicked:(id)sender
{
    if (m_deletion)
    {
        [[CCDirector sharedDirector] replaceScene:[DeckBuilderScene sceneWithDeckIndex:m_selected] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
    else
    {
        DeckSprite* but = m_buttons[m_selected];
        if (!but.m_disabled)
        {
//            [[CCDirector sharedDirector] replaceScene:<#(CCScene *)#>]
        }
    }
}

- (void) onEraseClicked:(id)sender
{
    if (g_player.m_decks[m_selected] == [NSNull null])
        return;
    
    [g_player.m_decks replaceObjectAtIndex:m_selected withObject:[NSNull null]];
    DeckSprite* but = m_buttons[m_selected];
    [but removeParent:self];
    
    DeckSprite* newSprite = [[DeckSprite alloc] initWithID:m_selected Position:[but position] ButtonAction:@selector(buttonPressed:) Parent:self Deletion:m_deletion];
    [newSprite addParent:self Zorder:SD_BUTTONS_Z];
    
    [m_buttons replaceObjectAtIndex:m_selected withObject:newSprite];
    
    [g_player saveData];
}

-(void) setEraseButtonPosition
{
    DeckSprite* but = m_buttons[m_selected];
    CGPoint pos = [but position];
    m_erase.position = ccp(pos.x + SD_CANCEL_BUTTON_X, pos.y + SD_CANCEL_BUTTON_Y);
    
    but = nil;
}

@end
