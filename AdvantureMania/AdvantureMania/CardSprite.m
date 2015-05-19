//
//  CardSprite.m
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "CardSprite.h"
#import "cocos2d.h"
#import "GlobalData.h"
#import "Card.h"


const float CS_LIMIT_FONT_SIZE     = 14;
const float CS_NAME_FONT_SIZE_S    = 9;
const float CS_NAME_FONT_SIZE_L    = 16;

const float CS_CARD_BG_X          = 0;
const float CS_CARD_BG_Y          = 0;
const float CS_CARD_BG_Z          = 0;

const float CS_LIMIT_LABEL_S_X         = 0;
const float CS_LIMIT_LABEL_S_Y         = -65.0f/SCREEN_Y;
const float CS_LIMIT_LABEL_L_X         = 0;
const float CS_LIMIT_LABEL_L_Y         = 110.0f/SCREEN_Y;
const float CS_LIMIT_LABEL_Z           = 0;

const float CS_NAME_LABEL_S_X         = -10.0f/SCREEN_X;
const float CS_NAME_LABEL_S_Y         = 43.0f/SCREEN_Y;
const float CS_NAME_LABEL_L_X         = -25.0f/SCREEN_X;
const float CS_NAME_LABEL_L_Y         = 82.0f/SCREEN_Y;
const float CS_NAME_LABEL_Z           = 1;

const float CS_NAME_LABEL_COLOR_R         = 99;
const float CS_NAME_LABEL_COLOR_G         = 215;
const float CS_NAME_LABEL_COLOR_B         = 217;

const float CS_ENERGY_LABEL_S_X         = 32.0f/SCREEN_X;
const float CS_ENERGY_LABEL_S_Y         = 44.0f/SCREEN_Y;
const float CS_ENERGY_LABEL_L_X         = 60.0f/SCREEN_X;
const float CS_ENERGY_LABEL_L_Y         = 82.0f/SCREEN_Y;
const float CS_ENERGY_LABEL_Z           = 1;

const float CS_ENERGY_LABEL_COLOR_R         = 255;
const float CS_ENERGY_LABEL_COLOR_G         = 120;
const float CS_ENERGY_LABEL_COLOR_B         = 0;

const float CS_PROP_ICON_S_X         = -23.0f/SCREEN_X;
const float CS_PROP_ICON_S_Y         = -20.0f/SCREEN_Y;
const float CS_PROP_ICON_S_STEP      = 23.0f/SCREEN_X;
const float CS_PROP_ICON_L_X         = -45.0f/SCREEN_X;
const float CS_PROP_ICON_L_Y         = -35.0f/SCREEN_Y;
const float CS_PROP_ICON_L_STEP      = 45.0f/SCREEN_X;
const float CS_PROP_ICON_Z           = 1;

const float CS_PROP_VALUE_S_X         = -23.0f/SCREEN_X;
const float CS_PROP_VALUE_S_Y         = -40.0f/SCREEN_Y;
const float CS_PROP_VALUE_S_STEP      = 23.0f/SCREEN_X;
const float CS_PROP_VALUE_L_X         = -45.0f/SCREEN_X;
const float CS_PROP_VALUE_L_Y         = -65.0f/SCREEN_Y;
const float CS_PROP_VALUE_L_STEP      = 45.0f/SCREEN_X;
const float CS_PROP_VALUE_Z           = 1;

@implementation Limit
@synthesize m_limit = m_limit, m_taken = m_taken;
+(Limit*) labelWithLimit:(int) limit Taken:(int) taken Text:(NSString*) text Font:(NSString*) font FontSize:(CGFloat) fontSize
{
    Limit* lim = [Limit labelWithString:text fontName:font fontSize:fontSize];
    lim.positionType = CCPositionTypeNormalized;
    lim.m_limit = limit;
    lim.m_taken = taken;
    return lim;
}

-(void) changeTakenByValue:(int)value
{
    m_taken+=value;
    NSString* str = [NSString stringWithFormat:@"%d/%d",m_taken,m_limit];
    [self setString:str];
}

@end

@implementation CardSprite
@synthesize
m_id = m_id,
m_background = m_background,
m_name = m_name,
m_encost = m_encost,
m_small = m_small,
m_highlighted = m_highlighted,
m_limit = m_limit,
m_icons = m_icons,
m_values = m_values;

-(CardSprite*) initWithId:(int) iid Position:(CGPoint)position Small:(BOOL)small Limit:(BOOL)limit Value:(int)value
{
    self = [super init];
    if (self)
    {
        m_id = iid;
        m_small = small;
        m_highlighted = NO;
        Card* card = g_data.m_cards[m_id];
        
        int i =0;
        NSMutableArray* arrayI = [NSMutableArray arrayWithCapacity:[card.m_actions count]];
        NSMutableArray* arrayV = [NSMutableArray arrayWithCapacity:[card.m_actions count]];
        
        if (small)
        {
            self.m_background = [CCSprite spriteWithImageNamed:@"card_s.png"];
            m_background.position=position;
            
            self.m_name = [CCLabelTTF labelWithString:card.m_name fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_S];
            m_name.position = ccp(position.x + CS_NAME_LABEL_S_X,position.y + CS_NAME_LABEL_S_Y);
            
            NSString* str = [NSString stringWithFormat:@"%d",card.m_encost];
            self.m_encost = [CCLabelTTF labelWithString:str fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_S];
            m_encost.position = ccp(position.x + CS_ENERGY_LABEL_S_X, position.y + CS_ENERGY_LABEL_S_Y);
            
            for (i=0;i<[card.m_actions count];i++)
            {
                NSDictionary* dict = card.m_actions[i];
                CCSprite* icon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d_s.png",[[dict objectForKey:@"type"] intValue]]];
                icon.positionType = CCPositionTypeNormalized;
                icon.position = ccp(position.x + CS_PROP_ICON_S_X + CS_PROP_ICON_S_STEP*i, position.y + CS_PROP_ICON_S_Y);
                [arrayI addObject:icon];
                
                CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"value"] intValue]] fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_S];
                label.position = ccp(position.x + CS_PROP_VALUE_S_X + CS_PROP_VALUE_S_STEP*i, position.y + CS_PROP_VALUE_S_Y);
                label.positionType = CCPositionTypeNormalized;
                [label setColor:[CCColor colorWithCcColor3b:ccc3(CS_NAME_LABEL_COLOR_R, CS_NAME_LABEL_COLOR_G, CS_NAME_LABEL_COLOR_B)]];
                [arrayV addObject:label];
                
                icon = nil;
                label = nil;
            }
            
            if (limit)
            {
                int lim = card.m_limit;
                NSString* str = [NSString stringWithFormat:@"%d/%d",value, lim];
                self.m_limit = [Limit labelWithLimit:lim Taken:value Text:str Font:FONT_NAME FontSize:CS_LIMIT_FONT_SIZE];
                [m_limit setPosition:ccp(position.x + CS_LIMIT_LABEL_S_X,position.y + CS_LIMIT_LABEL_S_Y)];
            }
        }
        else
        {
            self.m_background = [CCSprite spriteWithImageNamed:@"card.png"];
            [m_background setPosition:position];
            
            self.m_name = [CCLabelTTF labelWithString:card.m_name fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_L];
            [m_name setPosition:ccp(position.x + CS_NAME_LABEL_L_X,position.y + CS_NAME_LABEL_L_Y)];

            NSString* str = [NSString stringWithFormat:@"%d",card.m_encost];
            self.m_encost = [CCLabelTTF labelWithString:str fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_L];
            m_encost.position = ccp(position.x + CS_ENERGY_LABEL_L_X, position.y + CS_ENERGY_LABEL_L_Y);
            
            for (i=0;i<[card.m_actions count];i++)
            {
                NSDictionary* dict = card.m_actions[i];
                CCSprite* icon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.png",[[dict objectForKey:@"type"] intValue]]];
                icon.position = ccp(position.x +CS_PROP_ICON_L_X + CS_PROP_ICON_L_STEP*i,position.y+ CS_PROP_ICON_L_Y);
                icon.positionType = CCPositionTypeNormalized;
                [arrayI addObject:icon];
                
                CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"value"] intValue]] fontName:FONT_NAME fontSize:CS_NAME_FONT_SIZE_L];
                label.position = ccp(position.x + CS_PROP_VALUE_L_X + CS_PROP_VALUE_L_STEP*i, position.y + CS_PROP_VALUE_L_Y);
                label.positionType = CCPositionTypeNormalized;
                [arrayV addObject:label];
                [label setColor:[CCColor colorWithCcColor3b:ccc3(CS_NAME_LABEL_COLOR_R, CS_NAME_LABEL_COLOR_G, CS_NAME_LABEL_COLOR_B)]];
                
                icon = nil;
                label = nil;
            }
            
            if (limit)
            {
                Card* card = g_data.m_cards[m_id];
                int lim = card.m_limit;
                card = nil;
                NSString* str = [NSString stringWithFormat:@"%d/%d",value, lim];
                self.m_limit = [Limit labelWithLimit:lim Taken:value Text:str Font:FONT_NAME FontSize:CS_LIMIT_FONT_SIZE];
                [m_limit setPosition:ccp(position.x + CS_LIMIT_LABEL_L_X,position.y + CS_LIMIT_LABEL_L_Y)];
            }
        }
        
        m_background.positionType = CCPositionTypeNormalized;
        m_name.positionType = CCPositionTypeNormalized;
        m_encost.positionType = CCPositionTypeNormalized;
        
        [m_name setColor:[CCColor colorWithCcColor3b:ccc3(CS_NAME_LABEL_COLOR_R, CS_NAME_LABEL_COLOR_G, CS_NAME_LABEL_COLOR_B)]];
        [m_encost setColor:[CCColor colorWithCcColor3b:ccc3(CS_ENERGY_LABEL_COLOR_R, CS_ENERGY_LABEL_COLOR_G, CS_ENERGY_LABEL_COLOR_B)]];
        self.m_values = arrayV;
        self.m_icons = arrayI;
        
        card = nil;
        arrayI = nil;
        arrayV = nil;
    }
    
    return self;
}

-(void) addParent:(CCNode *)node Zorder:(NSInteger)z
{
    [node addChild:self.m_background z:z];
    [node addChild:self.m_name z:z + CS_NAME_LABEL_Z];
    [node addChild:self.m_encost z: z+CS_ENERGY_LABEL_Z];
    
    CCNode* n;
    for (int i = 0;i<[m_icons count];i++)
    {
        n = m_icons[i];
        [node addChild:n z:CS_PROP_ICON_Z+z];
        n = m_values[i];
        [node addChild:n z:CS_PROP_VALUE_Z+z];
    }
    
    n = nil;
    
    if (m_limit)
        [node addChild:self.m_limit z:z + CS_LIMIT_LABEL_Z];
}

-(void) removeParent:(CCNode *)node
{
    [node removeChild:self.m_background];
    [node removeChild:self.m_name];
    [node removeChild:self.m_encost];
    
    CCNode* n;
    for (int i = 0;i<[m_icons count];i++)
    {
        n = m_icons[i];
        [node removeChild:n];
        n = m_values[i];
        [node removeChild:n];
    }
    n = nil;
    
    if (m_limit)
        [node removeChild:self.m_limit];
}

-(void) MoveBy:(CGPoint)delta
{
    CCAction* action;
    action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
    [m_background runAction:action];
    
    action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
    [m_name runAction:action];
    
    action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
    [m_encost runAction:action];
    
    CCNode* n;
    for (int i = 0;i<[m_icons count];i++)
    {
        n = m_icons[i];
        action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
        [n runAction:action];
        
        n = m_values[i];
        action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
        [n runAction:action];
    }
    n= nil;
    
    if (m_limit)
    {
        action = [CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta];
        [m_limit runAction:action];
    }
}

-(void) stopAllActions
{
    [m_background stopAllActions];
    [m_limit stopAllActions];
    [m_name stopAllActions];
    [m_encost stopAllActions];
    
    CCNode* n;
    for (int i = 0;i<[m_icons count];i++)
    {
        n = m_icons[i];
        [n stopAllActions];
        
        n = m_values[i];
        
        [n stopAllActions];
    }
    n= nil;
}

-(void) dealloc
{
    self.m_background = nil;
    self.m_name = nil;
    self.m_encost = nil;
    self.m_limit = nil;
    self.m_values = nil;
    self.m_icons = nil;
}

-(CGPoint) position
{
    return m_background.position;
}

@end
