//
//  MainViewWindowController.m
//  AdvanureManiaDataCreator
//
//  Created by Owner Owner on 03.09.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "MainViewWindowController.h"
#import "Card.h"

@interface MainViewWindowController ()

@end

@implementation MainViewWindowController
@synthesize cardsArray = cardsArray, selectedArray = selectedArray, oldCardIndex;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void) dealloc
{
    NSRange r;
    r.length = [cardsArray count];
    r.location = 0;
    [cardsArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:r]];
    r.length = [selectedArray count];
    [selectedArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:r]];
    
    cardsArray = nil;
    selectedArray = nil;
}

- (void) awakeFromNib
{
    oldCardIndex = -1;
    [cardsTable setDelegate:self];
    
    self.cardsArray = [NSMutableArray array];
    self.selectedArray = [NSMutableArray array];
    
    NSArray* cards = [self loadCards];
    NSMutableArray* objects = [NSMutableArray arrayWithCapacity:[cards count]];
    
    int i;
    
    for (i=0; i<[cards count]; i++)
    {
        Card* card = cards[i];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [MainViewWindowController stringFromAbilitiesArray:card.m_actions], @"cardProperties",
                              card, @"object",
                              card.m_name, @"cardName", nil];
        [objects addObject:dict];
        dict = nil;
        card = nil;
    }
    
    [cardsArrayController addObjects:objects];
    objects = nil;
    
    [cardsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    
    [abilitiesCombo addItemsWithObjectValues:[NSArray arrayWithObjects:
                                              @"Step",@"if Step",
                                              @"Attack",@"if Attack",
                                              @"Defence",@"if Defence",
                                              @"Discard",@"if Discard",
                                              @"Take Card",@"Dicrease cost", nil]];
    
    [abilitiesCombo selectItemAtIndex:0];
    
    
//    [selectedArrayController addObject:[NSDictionary dictionaryWithObject:@"test123" forKey:@"property"]];
//    [cardsArrayController addObject:[NSDictionary dictionaryWithObject:@"test123" forKey:@"cardName"]];
//    [cardsArrayController addObject:[NSDictionary dictionaryWithObject:@"test123" forKey:@"cardName"]];
}

-(void) tableViewSelectionDidChange:(NSNotification *)notification
{
    if (notification.object == cardsTable)
    {
        int i;
        NSMutableArray* array;
        Card* card;
        NSMutableDictionary* cardDict;
        
        if (oldCardIndex !=-1)
        {
        
            array = [NSMutableArray arrayWithCapacity:[selectedArray count]];
        
            for (i=0;i<[selectedArray count];i++)
            {
                NSDictionary* dict = selectedArray[i];
                [array addObject:[dict objectForKey:@"object"]];
            }
        
            cardDict = cardsArray[oldCardIndex];
            card = [cardDict objectForKey:@"object"];
            card.m_actions = [NSArray arrayWithArray:array ];
            [cardDict removeObjectForKey:@"cardProperties"];
            [cardDict setObject:[MainViewWindowController stringFromAbilitiesArray:array] forKey:@"cardProperties"];
            array = nil;
        
        
            NSRange r;
            r.length = [selectedArray count];
            r.location = 0;
            [selectedArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:r]];
        }
        
        oldCardIndex =[cardsTable selectedRow];
        
        if (oldCardIndex != -1)
        {
            cardDict = cardsArray[oldCardIndex];
            card = [cardDict objectForKey:@"object"];
        
            array = [NSMutableArray arrayWithCapacity:[card.m_actions count]];
            for (i=0;i<[card.m_actions count];i++)
            {
                NSDictionary* dict = card.m_actions[i];
                [array addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[MainViewWindowController stringFromAbility:dict],@"property",dict,@"object", nil]];
            }
        
            [selectedArrayController addObjects:array];
        }
    }
        
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

+(NSString*) stringFromAbility:(NSDictionary*) dict
{
    NSString* str = @"";
    
    switch ([[dict objectForKey:@"type"] intValue])
    {
        case 0:
            str = [str stringByAppendingString:@"st"];
            break;
        case 1:
            str = [str stringByAppendingString:@"if_st"];
            break;
        case 2:
            str = [str stringByAppendingString:@"att"];
            break;
        case 3:
            str = [str stringByAppendingString:@"if_att"];
            break;
        case 4:
            str = [str stringByAppendingString:@"def"];
            break;
        case 5:
            str = [str stringByAppendingString:@"if_def"];
            break;
        case 6:
            str = [str stringByAppendingString:@"dis"];
            break;
        case 7:
            str = [str stringByAppendingString:@"if_disc"];
            break;
        case 8:
            str = [str stringByAppendingString:@"take"];
            break;
        case 9:
            str = [str stringByAppendingString:@"dic"];
            break;
        default:
            break;
    }
    
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"value"] intValue]]];
    
    return str;
    
}

+(NSString*) stringFromAbilitiesArray:(NSArray*) abilities
{
    NSString* str=@"";
    
    for (int i=0;i<[abilities count];i++)
    {
        NSDictionary* dict = abilities[i];
        
        str = [str stringByAppendingString:[MainViewWindowController stringFromAbility:dict]];
    }
    
    return  str;
}

-(NSArray*) loadCards
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* path = @"/Users/ownerowner/Desktop/Oleg/AdvantureMania/amdata.sqlite";//[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"amdata.sqlite"];
    sqlite3* database;
    
    if (sqlite3_open([path UTF8String],&database) == SQLITE_OK)
    {
        const char* sql_s = "SELECT pk FROM cards";
        sqlite3_stmt* statement;
        
        if (sqlite3_prepare_v2(database, sql_s, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int pk = sqlite3_column_int(statement, 0);
                
                Card* newCard = [[Card alloc] initWithPrimaryKey:pk database:database];
                [array addObject:newCard];
                newCard = nil;
            }
            
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(database);
    
    return array;
}

-(void) saveCards:(NSArray *)cards
{
    NSString* path = @"/Users/ownerowner/Desktop/Oleg/AdvantureMania/amdata.sqlite";
    sqlite3* database;
    
    if (sqlite3_open([path UTF8String],&database) == SQLITE_OK)
    {
        for (Card* card in cards)
            [card saveToDatabase:database];
    }
    
    sqlite3_close(database);
}

-(IBAction) addButton:(id)sender
{
    NSNumber* type = [NSNumber numberWithInt:(int) [abilitiesCombo indexOfSelectedItem]];
    NSNumber* value = [NSNumber numberWithInt:[amountTextField intValue]];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",value,@"value", nil];
    type = nil;
    value = nil;
    
    NSDictionary* selDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             dict,@"object",
                             [MainViewWindowController stringFromAbility:dict],@"property", nil];
    dict = nil;
    [selectedArrayController addObject:selDict];
    selDict = nil;
}

-(IBAction)eraseButton:(id)sender
{
    if ([selectedArrayController selectionIndex] != -1 )
        [selectedArrayController removeObjectAtArrangedObjectIndex:[selectedArrayController selectionIndex]];
}

-(IBAction)downButton:(id)sender
{
    NSInteger index = [selectedArrayController selectionIndex];
    
    if (index == -1)
        return;
    
    if (index == [selectedArray count]-1)
        return;
    
    NSDictionary* dict = selectedArray[index];
    [selectedArrayController removeObjectAtArrangedObjectIndex:index];
    index++;
    [selectedArrayController insertObject:dict atArrangedObjectIndex:index];
}

-(IBAction)upButton:(id)sender
{
    NSInteger index = [selectedArrayController selectionIndex];
    
    if (index <1)
        return;
    
    NSDictionary* dict = selectedArray[index];
    [selectedArrayController removeObjectAtArrangedObjectIndex:index];
    index--;
    [selectedArrayController insertObject:dict atArrangedObjectIndex:index];
}

-(IBAction)saveButton:(id)sender
{
    [cardsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:(0==oldCardIndex ? 1 : 0)] byExtendingSelection:NO];
    int i;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[cardsArray count]];
    
    for (i=0;i<[cardsArray count];i++)
    {
        NSDictionary* dict = cardsArray[i];
        Card* card = dict[@"object"];
        [array addObject:card];
    }
    
    [self saveCards:array];
    array = nil;
}

@end
