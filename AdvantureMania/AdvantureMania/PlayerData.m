//
//  PlayerData.m
//  AdvantureMania
//
//  Created by Owner Owner on 31.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "PlayerData.h"
#import "Deck.h"

@implementation PlayerData
@synthesize
m_decks = m_decks,
m_name = m_name;

-(PlayerData*) init
{
    self = [super init];
    if (self)
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* writablePath = [documentsDirectory stringByAppendingPathComponent:@"AdvantureManiaPlayerSave.sav"];
        
        if (![fileManager fileExistsAtPath:writablePath isDirectory:NULL])
        {
            self.m_name = @"Player";
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:AMOUNT_OF_DECKS];
            for (int i =0;i<AMOUNT_OF_DECKS;i++)
                [array addObject:[NSNull null]];
            
            self.m_decks = array;
            
            array = [NSMutableArray arrayWithCapacity:DECK_SIZE];
            for (int i = 0;i<DECK_SIZE;i++)
                [array addObject:[NSNumber numberWithInt:i]];
            
            Deck* deck = [[Deck alloc] initWithArray:array Name:@"Basic deck"];
            [m_decks replaceObjectAtIndex:0 withObject:deck];
            array = nil;
            deck = nil;
            
            [fileManager createFileAtPath:writablePath contents:nil attributes:nil];
            [self saveData];
        }
        else
        {
            NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:writablePath];
            NSData* data = [file readDataToEndOfFile];
        
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.m_name = [dict objectForKey:@"name"];
        
            NSArray* decks = [dict objectForKey:@"decks"];
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:AMOUNT_OF_DECKS];
        
            int i;
            for (i=0;i<AMOUNT_OF_DECKS;i++)
            {
                id obj = decks[i];
            
                if (obj == [NSNull null])
                {
                    [array addObject:obj];
                }
                else
                {
                    Deck* deck = [[Deck alloc] initWithDictionary:(NSDictionary*) obj] ;
                    [array addObject:deck];
                    deck = nil;
                }
            }
        
            self.m_decks = array;
            array = nil;
            decks = nil;
            dict = nil;
        
            [file closeFile];
        }
    }
    
    return self;
}

-(void) dealloc
{
    self.m_decks = nil;
    self.m_name = nil;
}

-(void) saveData
{
    NSMutableArray* decks = [NSMutableArray arrayWithCapacity:AMOUNT_OF_DECKS];
    int i;
    
    for (i=0;i<AMOUNT_OF_DECKS;i++)
    {
        id obj = m_decks[i];
        
        if (obj == [NSNull null])
        {
            [decks addObject:obj];
        }
        else
        {
            Deck* deck = (Deck*) obj;
            [decks addObject:[deck toDictionary]];
        }
    }
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:m_name,@"name",decks,@"decks", nil];
    decks = nil;
    
    if ([NSJSONSerialization isValidJSONObject:dictionary])
    {
        NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* writablePath = [documentsDirectory stringByAppendingPathComponent:@"AdvantureManiaPlayerSave.sav"];
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:writablePath contents:nil attributes:nil];
        
        NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:writablePath];
        [file writeData:data];
        
        data = nil;
        
        [file closeFile];
    }
    
    dictionary = nil;
}


@end
