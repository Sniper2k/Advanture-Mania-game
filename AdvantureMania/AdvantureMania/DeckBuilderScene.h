//
//  DeckBuilderScene.h
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@class CardSprite;
@interface DeckBuilderScene : CCScene
@property (retain) NSMutableArray* m_allCards;
@property (retain) NSMutableArray* m_deck;
@property (assign) CGPoint m_enterTouch;
@property (assign) BOOL m_touchMoving;
@property (assign) float m_scrollAllPosition, m_scrollDeckPosition, m_scrollAllLimit, m_scrollDeckLimit;
@property (retain) CardSprite* m_selectedCard;
@property (retain) CardSprite* m_lastSelected;
@property (retain) CCButton* m_addCardButton;
@property (retain) CCButton* m_removeCardButton;
@property (retain) CCLabelTTF* m_deckFullLabel;
@property (retain) CCLabelTTF* m_cardLimitLabel;
@property (retain) CCTextField* m_deckName;
@property (assign) int m_cardsInDeck;
@property (assign) NSInteger m_deckIndex;
@property (retain) CCSprite* m_highlight;

+ (DeckBuilderScene *)sceneWithDeckIndex:(NSInteger) index;
- (id)initWithDeckIndex:(NSInteger) index;
- (void)loadDeck:(NSInteger) index;

- (void) createCardsSprites;
- (void) addMoveActonToArrayOfCards:(NSArray*) cards ScrollPosition:(float*) scrollPostionP ScrollLimit:(float*) scrollLimitP withDelta:(CGPoint) delta;
- (void) selectCardFromArray:(NSArray*) cards ScrollPosition:(float) scrollposition YCoordinate:(float) ycoord;


- (void) dispatchMovingTouch:(CGPoint) touch;
- (void) dispatchEndedTouch:(CGPoint) touch;

- (void) addCardPressed;
- (void) removeCardPressed;
- (void) setButtonsVisiblity:(BOOL) add Remove:(BOOL) remove Limit:(BOOL) limit;

- (CardSprite*) spriteWithId:(int) iid;
- (void)onBackClicked:(id)sender;
// -----------------------------------------------------------------------
@end
