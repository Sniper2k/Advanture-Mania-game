//
//  DeckBuilderScene.m
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "DeckBuilderScene.h"
#import "MainMenuScene.h"
#import "Card.h"
#import "CardSprite.h"
#import "GlobalData.h"
#import "MathFunctions.h"
#import "Deck.h"
#import "SelectDeckScene.h"

const float DB_ALL_CARD_X      = 60.0f/SCREEN_X;
const float DB_ALL_CARD_Y      = 230.0f/SCREEN_Y;
const float DB_ALL_CARD_Z      = 1;

const float DB_DECK_CARD_X     = DB_ALL_CARD_X;
const float DB_DECK_CARD_Y     = 80.0f/SCREEN_Y;
const float DB_DECK_CARD_Z     = DB_ALL_CARD_Z;

const float DB_CARD_STEP       = 90.0f/SCREEN_X;
const float DB_SLIDE_LIMIT_X   = 400.0f/SCREEN_X;
const float DB_SLIDE_LIMIT_Y   = 160.0f/SCREEN_Y;
const float DB_SLIDE_DELTA_MIN = 10.0f/SCREEN_X;
const float DB_MAX_CARDS       = 4;
const float DB_CARD_HW         = 40.0f/SCREEN_X;
const float DB_CARD_HH         = 63.25f/SCREEN_Y;

const float DB_CARD_APEAR_TIME = 0.5f;

const float DB_VIEWCARD_BG_X   = 484.0f/SCREEN_X;
const float DB_VIEWCARD_BG_Y   = 160.0f/SCREEN_Y;
const float DB_VIEWCARD_BG_Z   = 5;

const float DB_SELECTED_X      = DB_VIEWCARD_BG_X;
const float DB_SELECTED_Y      = DB_VIEWCARD_BG_Y;
const float DB_SELECTED_Z      = DB_VIEWCARD_BG_Z+1;

const float DB_BUTTON_X    = 484.0f/SCREEN_X;
const float DB_BUTTON_Y    = 30.0f/SCREEN_Y;
const float DB_BUTTON_Z    = DB_VIEWCARD_BG_Z+5;

const float DB_TEXT_FIELD_X    = 100.0f/SCREEN_X;
const float DB_TEXT_FIELD_Y    = 135.0f/SCREEN_Y;
const float DB_TEXT_FIELD_Z    = DB_VIEWCARD_BG_Z;

const float DB_FONT_SIZE_NORMAL    = 18;
const float DB_FONT_SIZE_SMALL     = 14;

const float DB_HIGHLIGHT_Z     = DB_ALL_CARD_Z+3;

@implementation DeckBuilderScene
@synthesize
m_addCardButton = m_addCardButton,
m_removeCardButton = m_removeCardButton,
m_allCards = m_allCards,
m_deck = m_deck,
m_enterTouch = m_enterTouch,
m_touchMoving = m_touchMoving,
m_scrollAllLimit = m_scrollAllLimit,
m_scrollAllPosition = m_scrollAllPosition,
m_scrollDeckLimit = m_scrollDeckLimit,
m_scrollDeckPosition = m_scrollDeckPosition,
m_selectedCard= m_selectedCard,
m_lastSelected = m_lastSelected,
m_deckFullLabel = m_deckFullLabel,
m_cardLimitLabel = m_cardLimitLabel,
m_cardsInDeck = m_cardsInDeck,
m_deckIndex = m_deckIndex,
m_deckName = m_deckName,
m_highlight = m_highlight;
// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (DeckBuilderScene *)sceneWithDeckIndex:(NSInteger)index
{
    return [[self alloc] initWithDeckIndex:index];
}

// -----------------------------------------------------------------------

- (id)initWithDeckIndex:(NSInteger)index
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"Save" fontName:FONT_NAME fontSize:DB_FONT_SIZE_NORMAL];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton z:DB_BUTTON_Z];
    
    m_touchMoving = NO;
    
    CCSprite* viewCardBg = [CCSprite spriteWithImageNamed:@"ViewCardBackground.png"];
    viewCardBg.positionType = CCPositionTypeNormalized;
    [viewCardBg setPosition:ccp(DB_VIEWCARD_BG_X,DB_VIEWCARD_BG_Y)];
    [self addChild:viewCardBg z:DB_VIEWCARD_BG_Z];
    
    self.m_selectedCard = nil;
    self.m_lastSelected = nil;
    
    self.m_addCardButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"AddToDeckButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"AddToDeckButton.png"] disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"AddToDeckButton.png"]];
    [m_addCardButton setTarget:self selector:@selector(addCardPressed)];
    [m_addCardButton setVisible:NO];
    m_addCardButton.positionType = CCPositionTypeNormalized;
    [m_addCardButton setPosition:ccp(DB_BUTTON_X,DB_BUTTON_Y)];
    [self addChild:self.m_addCardButton z:DB_BUTTON_Z];
    
    self.m_removeCardButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"RemoveCardButton.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"RemoveCardButton.png"] disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"RemoveCardButton.png"]];
    [m_removeCardButton setTarget:self selector:@selector(removeCardPressed)];
    [m_removeCardButton setVisible:NO];
    m_removeCardButton.positionType = CCPositionTypeNormalized;
    [m_removeCardButton setPosition:ccp(DB_BUTTON_X,DB_BUTTON_Y)];
    [self addChild:self.m_removeCardButton z:DB_BUTTON_Z];
    
    self.m_deckFullLabel = [CCLabelTTF labelWithString:@"Deck Full!" fontName:FONT_NAME fontSize:DB_FONT_SIZE_NORMAL];
    m_deckFullLabel.positionType = CCPositionTypeNormalized;
    [m_deckFullLabel setPosition:ccp(DB_BUTTON_X,DB_BUTTON_Y)];
    [m_deckFullLabel setVisible:NO];
    [self addChild:self.m_deckFullLabel z:DB_BUTTON_Z];
    
    self.m_cardLimitLabel = [CCLabelTTF labelWithString:@"Card Limit\n Reached!" fontName:FONT_NAME fontSize:DB_FONT_SIZE_NORMAL];
    m_cardLimitLabel.positionType = CCPositionTypeNormalized;
    [m_cardLimitLabel setPosition:ccp(DB_BUTTON_X,DB_BUTTON_Y)];
    [m_cardLimitLabel setVisible:NO];
    [self addChild:self.m_cardLimitLabel z:DB_BUTTON_Z];
    
    CCSprite *textSprite = [CCSprite spriteWithImageNamed:@"TextTile.png"];
    self.m_deckName = [CCTextField textFieldWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"TextTile.png"]];
    m_deckName.textField.font = [UIFont fontWithName:FONT_NAME size:DB_FONT_SIZE_NORMAL];
    m_deckName.textField.textColor = [UIColor whiteColor];
    m_deckName.contentSize = textSprite.contentSize;
    m_deckName.preferredSize = textSprite.contentSize;
    m_deckName.positionType = CCPositionTypeNormalized;
    m_deckName.position = ccp(DB_TEXT_FIELD_X, DB_TEXT_FIELD_Y);
    
    self.m_highlight = [CCSprite spriteWithImageNamed:@"highlight_s.png"];
    m_highlight.positionType = CCPositionTypeNormalized;
    m_highlight.position = ccp(-1,-1);
    [self addChild:self.m_highlight z:DB_HIGHLIGHT_Z];
    
    [self addChild:self.m_deckName z:DB_TEXT_FIELD_Z];
    textSprite = nil;
    
    [self loadDeck:index];
    
    // done
	return self;
}

-(void) loadDeck:(NSInteger)index
{
    m_deckIndex = index;
    m_cardsInDeck = 0;
    [self createCardsSprites];
    
    if (g_player.m_decks[m_deckIndex] == [NSNull null])
        m_deckName.string = @"Write Deck Name...";
    else
    {
        Deck* deck = g_player.m_decks[m_deckIndex];
        m_deckName.string = deck.m_name;
        deck = nil;
    }
}

-(void) createCardsSprites
{
    int i=0;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[g_data.m_cards count]];
    
    for (Card* card in g_data.m_cards)
    {
        CGPoint pos = ccp(DB_ALL_CARD_X+i*DB_CARD_STEP, DB_ALL_CARD_Y);
        CardSprite* sprite = [[CardSprite alloc] initWithId:card.m_id Position:pos Small:YES Limit:NO Value:0];
        [sprite addParent:self Zorder:DB_ALL_CARD_Z];
        [array addObject:sprite];
        sprite = nil;
        i++;
    }
    
    self.m_allCards = array;
    
    
    array = [NSMutableArray array];
    
    if (g_player.m_decks[m_deckIndex] != [NSNull null])
    {
        Deck* deck = g_player.m_decks[m_deckIndex];
        i=0;
        for (NSNumber* cardId in deck.m_cards)
        {
            CardSprite* lastObject = [array lastObject];
            
            BOOL state1,state2=NO;
            state1 = (lastObject != nil);
            if (state1)
                state2 = (lastObject.m_id == [cardId intValue]);
            
            if (state1 && state2)
            {
                [lastObject.m_limit changeTakenByValue:1];
            }
            else
            {
                CGPoint pos = ccp(DB_DECK_CARD_X+i*DB_CARD_STEP, DB_DECK_CARD_Y);
                
                Card* card = g_data.m_cards[[cardId intValue]];
                
                CardSprite* sprite = [[CardSprite alloc] initWithId:card.m_id Position:pos Small:YES Limit:YES Value:1];
                [sprite addParent:self Zorder:DB_DECK_CARD_Z];
                [array addObject:sprite];
                i++;
                
                sprite = nil;
                card = nil;
            }
            
            lastObject = nil;
            m_cardsInDeck++;
        }
    }
    
    self.m_deck = array;
    array = nil;
    
    m_scrollAllPosition = 0;
    m_scrollDeckPosition = 0;
    m_scrollAllLimit = DB_CARD_STEP*([g_data.m_cards count] - DB_MAX_CARDS);
    m_scrollDeckLimit = DB_CARD_STEP*(MAX(0,[m_deck count] - DB_MAX_CARDS));
    
}

-(void) addMoveActonToArrayOfCards:(NSArray *)cards ScrollPosition:(float *)scrollPostionP ScrollLimit:(float *)scrollLimitP withDelta:(CGPoint)delta
{
    *scrollPostionP += delta.x;
    
    if (*scrollPostionP<0)
    {
        delta.x += fabsf(*scrollPostionP);
        *scrollPostionP = 0;
    }
    
    if (*scrollPostionP>*scrollLimitP)
    {
        delta.x -= *scrollPostionP - *scrollLimitP;
        *scrollPostionP = *scrollLimitP;
    }
    
    if (delta.x == 0)
        return;
    
    delta.x *=-1;
    
    for (CardSprite* card in cards)
        [card MoveBy:delta];
    
    if (m_highlight.position.y != -1)
        if (!((cards == m_allCards) ^ (m_highlight.position.y>DB_SLIDE_LIMIT_Y)))
                [m_highlight runAction:[CCActionMoveBy actionWithDuration:CS_MOVEBY_TIME position:delta]];
}

-(void) selectCardFromArray:(NSArray *)cards ScrollPosition:(float)scrollposition YCoordinate:(float)ycoord
{
    if (m_enterTouch.y> ycoord + DB_CARD_HH || m_enterTouch.y< ycoord - DB_CARD_HH)
        return;
    
    float realPosition = (m_enterTouch.x + scrollposition - DB_ALL_CARD_X + DB_CARD_HW);
    
    if (realPosition<0)
        return;
    
    
    NSInteger index = (NSInteger) (realPosition / (DB_CARD_STEP));
    
    if (index >= [cards count])
        return;
    
    realPosition -= index*DB_CARD_STEP;
    
    if (realPosition>2*DB_CARD_HW)
        return;
    
    if (m_selectedCard)
    {
        [m_selectedCard removeParent:self];
    }
    
    self.m_lastSelected = cards[index];
    
    int value=0;
    CardSprite* sprite = [self spriteWithId:m_lastSelected.m_id];

    if (sprite)
        value = sprite.m_limit.m_taken;
    
    self.m_selectedCard = [[CardSprite alloc] initWithId:m_lastSelected.m_id Position:ccp(DB_SELECTED_X,DB_SELECTED_Y) Small:NO Limit:YES Value:value];
    [m_selectedCard addParent:self Zorder:DB_SELECTED_Z];
    //[m_selectedCard.m_sprite addAction:[CCActionFadeIn actionWithDuration:CARD_APEAR_TIME]];
    
    m_highlight.position = [m_lastSelected position];
    
    BOOL limit= (value == m_selectedCard.m_limit.m_limit);
    
    [self setButtonsVisiblity:cards == m_allCards Remove:NO Limit:limit];
    
    sprite = nil;
}

- (CardSprite*) spriteWithId:(int)iid
{
    NSInteger index = [m_deck indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL* stop){
        CardSprite *sprite = (CardSprite*)obj;
        BOOL ret = (sprite.m_id == iid);
        return ret;
    }];
    
    if (index == NSNotFound)
        return nil;
    
    CardSprite* sprite = m_deck[index];
    return sprite;
}


// -----------------------------------------------------------------------

- (void)dealloc
{
    [self removeAllChildren];
    self.m_deck = nil;
    self.m_selectedCard = nil;
    self.m_lastSelected = nil;
    self.m_allCards = nil;
    self.m_addCardButton = nil;
    self.m_removeCardButton = nil;
    self.m_deckFullLabel = nil;
    self.m_cardLimitLabel = nil;
    self.m_deckName = nil;
    self.m_highlight = nil;
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    
    
    // always call super onExit last
    [super onExit];
}

-(void) addCardPressed
{
    CardSprite* sprite = [self spriteWithId:m_selectedCard.m_id];
    
    if (sprite)
    {
        [sprite.m_limit changeTakenByValue:1];
    }
    else
    {
        CGPoint pos;
        if ([m_deck count])
        {
            CardSprite* ls =[m_deck lastObject];
            pos = [ls position];
            ls = nil;
            pos.x += DB_CARD_STEP;
        }
        else
        {
            pos =ccp(DB_DECK_CARD_X, DB_DECK_CARD_Y);
        }
        
        sprite = [[CardSprite alloc] initWithId:m_selectedCard.m_id Position:pos Small:YES Limit:YES Value:1];
        [m_deck addObject:sprite];
        [sprite addParent:self Zorder:DB_DECK_CARD_Z];
        
        if ([m_deck count]>DB_MAX_CARDS)
            m_scrollDeckLimit+=DB_CARD_STEP;
    }
    
    [m_selectedCard.m_limit changeTakenByValue:1];
    m_cardsInDeck++;
    [self setButtonsVisiblity:YES Remove:NO Limit:sprite.m_limit.m_taken == sprite.m_limit.m_limit];
    
    sprite = nil;
}

-(void) removeCardPressed
{
    CardSprite* sprite = [self spriteWithId:m_selectedCard.m_id];
    
    BOOL remove = NO;
    
    if (sprite.m_limit.m_taken == 1)
    {
        NSInteger i = [m_deck indexOfObject:sprite];
        [sprite removeParent:self];
        
        if ([m_deck count]>DB_MAX_CARDS)
            m_scrollDeckLimit-=DB_CARD_STEP;
        
        [m_deck removeObjectAtIndex:i];
        
        CGPoint delta = ccp(-DB_CARD_STEP, 0);
        for (;i<[m_deck count];i++)
            [m_deck[i] MoveBy:delta];
        
        
        
        [m_selectedCard removeParent:self];
        self.m_selectedCard = nil;
        self.m_highlight.position = ccp(0,-1);
        remove = YES;
    }
    else
    {
        [sprite.m_limit changeTakenByValue:-1];
        [m_selectedCard.m_limit changeTakenByValue:-1];
    }
    
    m_cardsInDeck--;
    [self setButtonsVisiblity:NO Remove:remove Limit:YES];
    
    sprite = nil;
}

-(void) setButtonsVisiblity:(BOOL)add Remove:(BOOL)remove Limit:(BOOL)limit
{
    if (add)
    {
        [m_removeCardButton setVisible:NO];
        
        if (m_cardsInDeck == DECK_SIZE)
        {
            [m_deckFullLabel setVisible:YES];
            [m_addCardButton setVisible:NO];
            [m_cardLimitLabel setVisible:NO];
        }
        else
        {
            if (limit)
            {
                [m_deckFullLabel setVisible:NO];
                [m_addCardButton setVisible:NO];
                [m_cardLimitLabel setVisible:YES];
            }
            else
            {
                [m_deckFullLabel setVisible:NO];
                [m_addCardButton setVisible:YES];
                [m_cardLimitLabel setVisible:NO];
            }
        }
    }
    else
    {
        [m_addCardButton setVisible:NO];
        [m_cardLimitLabel setVisible:NO];
        [m_deckFullLabel setVisible:NO];
        
        if (remove)
        {
            [m_removeCardButton setVisible:NO];
        }
        else
        {
            [m_removeCardButton setVisible:YES];
        }
    }
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    m_enterTouch = [touch locationInNode:self];
    m_enterTouch = ccp(m_enterTouch.x/SCREEN_X,m_enterTouch.y/SCREEN_Y);
    // Log touch location
    
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(m_enterTouch));
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];
    touchLoc = ccp(touchLoc.x/SCREEN_X,touchLoc.y/SCREEN_Y);
    [self dispatchMovingTouch:touchLoc];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];
    touchLoc = ccp(touchLoc.x/SCREEN_X,touchLoc.y/SCREEN_Y);
    [self dispatchEndedTouch:touchLoc];
}

-(void) dispatchMovingTouch:(CGPoint)touch
{
    if (fabsf(m_enterTouch.x-touch.x)<DB_SLIDE_DELTA_MIN)
        return;
    
    if (m_enterTouch.x>DB_SLIDE_LIMIT_X)
        return;
    
    m_touchMoving = YES;
    CGPoint delta = ccp( - touch.x + m_enterTouch.x, 0);
    
    if (m_enterTouch.y>DB_SLIDE_LIMIT_Y)
    {
        [self addMoveActonToArrayOfCards:m_allCards ScrollPosition:&m_scrollAllPosition ScrollLimit:&m_scrollAllLimit withDelta:delta];
    }
    else
    {
        [self addMoveActonToArrayOfCards:m_deck ScrollPosition:&m_scrollDeckPosition ScrollLimit:&m_scrollDeckLimit withDelta:delta];
        
    }
    
    m_enterTouch = touch;
}

-(void) dispatchEndedTouch:(CGPoint)touch
{
    if (!m_touchMoving)
    {
        if (touch.x<DB_SLIDE_LIMIT_X)
        {
            if (m_enterTouch.y>DB_SLIDE_LIMIT_Y)
            {
                [self selectCardFromArray:m_allCards ScrollPosition:m_scrollAllPosition YCoordinate:DB_ALL_CARD_Y];
            }
            else
            {
                [self selectCardFromArray:m_deck ScrollPosition:m_scrollDeckPosition YCoordinate:DB_DECK_CARD_Y];
            }
        }
    }
    
    m_touchMoving = NO;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    int i;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[m_deck count]];
    
    for (CardSprite* sprite in m_deck)
    {
        for (i=0;i<sprite.m_limit.m_taken;i++)
        {
            [array addObject:[NSNumber numberWithInt:sprite.m_id]];
        }
    }
    
    [array sortUsingComparator:^NSComparisonResult(NSNumber* a,NSNumber* b){
        int y1 = [a intValue];
        int y2 = [b intValue];
        return (y1>y2);
    }];
    
    NSString* name = m_deckName.string;
    Deck* newDeck = [[Deck alloc] initWithArray:array Name:name];
    array = nil;
    name = nil;
    
    [g_player.m_decks replaceObjectAtIndex:m_deckIndex withObject:newDeck];
    newDeck = nil;
    
    [g_player saveData];
    
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectDeckScene sceneWithEnabledDeletion:YES]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end