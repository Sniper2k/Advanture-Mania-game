//
//  DeckSprite.m
//  AdvantureMania
//
//  Created by Owner Owner on 20.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "DeckSprite.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GlobalData.h"
#import "Deck.h"

const float DS_NAME_FONT_SIZE_S    = 9;
const float DS_NAME_FONT_SIZE_L    = 22;

const float DS_NAME_LABEL_X         = 0;
const float DS_NAME_LABEL_Y         = -30.0f/SCREEN_Y;
const float DS_NAME_LABEL_Z         = 1;

const float DS_NAME_LABEL_COLOR_R         = 99;
const float DS_NAME_LABEL_COLOR_G         = 215;
const float DS_NAME_LABEL_COLOR_B         = 217;

const float DS_BORDER_Z            = 1;
const float DS_DISABLED_Z          = 2;
const float DS_IMAGE_Z             = 0;

@implementation DeckSprite
@synthesize
m_border = m_border,
m_image = m_image,
m_name = m_name,
m_disabled = m_disabled;

-(DeckSprite*) initWithID:(NSInteger)idd Position:(CGPoint)position ButtonAction:(SEL)selector Parent:(CCNode *)parent Deletion:(BOOL)deletion
{
    self = [super init];
    if (self)
    {
        self.m_border = [CCSprite spriteWithImageNamed:@"DeckButtonBorder.png"];
        m_border.positionType = CCPositionTypeNormalized;
        m_border.position=position;
        
        id obj = g_player.m_decks[idd];
        
        if (obj == [NSNull null])
        {
            self.m_image = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"] disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"]];
            self.m_name = [CCLabelTTF labelWithString:@"No deck" fontName:FONT_NAME fontSize:DS_NAME_FONT_SIZE_S];
            
            if (!deletion)
            {
                self.m_disabled = [CCSprite spriteWithImageNamed:@"DeckButtonDisabled.png"];
                m_disabled.positionType = CCPositionTypeNormalized;
                m_disabled.position = position;
            }
        }
        else
        {
            Deck* deck = (Deck*) obj;
            
            self.m_name = [CCLabelTTF labelWithString:deck.m_name fontName:FONT_NAME fontSize:DS_NAME_FONT_SIZE_S];
            
            self.m_image = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"] disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"DeckButton.png"]];
            
            if (!deletion && ([deck.m_cards count]!= DECK_SIZE))
            {
                self.m_disabled = [CCSprite spriteWithImageNamed:@"DeckButtonDisabled.png"];
                m_disabled.positionType = CCPositionTypeNormalized;
                m_disabled.position = position;
            }
        }
        
        
        m_name.position = ccp(position.x + DS_NAME_LABEL_X,position.y + DS_NAME_LABEL_Y);
        m_name.positionType = CCPositionTypeNormalized;
        m_image.position = position;
        m_image.positionType = CCPositionTypeNormalized;
        [m_image setTarget:parent selector:selector];
    }
    
    return self;
}

-(void) addParent:(CCNode *)node Zorder:(NSInteger)z
{
    [node addChild:self.m_border z:z + DS_BORDER_Z];
    [node addChild:self.m_image z:z + DS_IMAGE_Z];
    [node addChild:self.m_name z:z + DS_NAME_LABEL_Z];
    
    if (m_disabled)
        [node addChild:self.m_disabled z: z +DS_DISABLED_Z];
}

-(void) removeParent:(CCNode *)node
{
    [node removeChild:self.m_border];
    [node removeChild:self.m_image];
    [node removeChild:self.m_name];
    
    if (m_disabled)
        [node removeChild:self.m_disabled];
}

-(void) dealloc
{
    self.m_border = nil;
    self.m_image = nil;
    self.m_name = nil;
    self.m_disabled = nil;
}

-(CGPoint) position
{
    return m_border.position;
}


@end
