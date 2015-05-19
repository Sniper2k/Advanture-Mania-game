//
//  Data.m
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "Data.h"
#import <sqlite3.h>
#import "Card.h"

@implementation Data
@synthesize
m_cards = m_cards;

-(Data*) init
{
    self = [super init];
    if (self)
    {
        [self loadCards];
    }
    
    return self;
}

-(void) loadCards
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"amdata.sqlite"];
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
            self.m_cards = array;
            array  = nil;
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(database);
    
}

-(void) dealloc
{
    self.m_cards = nil;
}

@end
