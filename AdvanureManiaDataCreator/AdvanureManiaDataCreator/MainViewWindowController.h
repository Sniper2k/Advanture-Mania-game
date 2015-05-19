//
//  MainViewWindowController.h
//  AdvanureManiaDataCreator
//
//  Created by Owner Owner on 03.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewWindowController : NSWindowController <NSTableViewDelegate>
{
    IBOutlet NSTableView* cardsTable;
    IBOutlet NSTableView* selectedAbilitiesTable;
    IBOutlet NSComboBox* abilitiesCombo;
    IBOutlet NSTextField* amountTextField;
    
    IBOutlet NSArrayController* cardsArrayController;
    IBOutlet NSArrayController* selectedArrayController;
    
    
    
    NSMutableArray* cardsArray;
    NSMutableArray* selectedArray;
}
@property (assign) NSInteger oldCardIndex;

-(IBAction)addButton:(id)sender;
-(IBAction)eraseButton:(id)sender;
-(IBAction)downButton:(id)sender;
-(IBAction)upButton:(id)sender;
-(IBAction)saveButton:(id)sender;

-(NSArray*) loadCards;
-(void) saveCards:(NSArray*) cards;

+(NSString*) stringFromAbility:(NSDictionary*) dict;
+(NSString*) stringFromAbilitiesArray:(NSArray*) abilities;

@property (retain) NSMutableArray* cardsArray;
@property (retain) NSMutableArray* selectedArray;
@end
