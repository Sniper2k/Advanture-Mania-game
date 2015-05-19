//
//  Card.m
//  AdvantureMania
//
//  Created by Owner Owner on 26.08.14.
//  Copyright (c) 2014 Sniper. All rights reserved.
//

#import "Card.h"

static sqlite3_stmt* init_statement=nil;
static sqlite3_stmt* update_statement=nil;

@implementation Card
@synthesize
m_id = m_id,
m_limit=m_limit,
m_encost=m_encost,
m_actions=m_actions,
m_name = m_name;

-(Card *)init
{
    self = [super init];
    if (self)
    {
        
        
    }
    
    return self;
}

-(Card*) initWithCard:(Card *)card
{
    self = [super init];
    if (self)
    {
        self.m_name = card.m_name;
        self.m_actions = card.m_actions;
        m_id = card.m_id;
        m_limit = card.m_limit;
        m_encost = card.m_encost;
    }
    
    return self;
}

-(Card*) initWithPrimaryKey:(int)pk database:(sqlite3 *)db
{
    self = [super init];
    if (self)
    {
        m_id = pk-1;
        sqlite3* database = db;
        
        if (init_statement == nil)
        {
            const char* sql = "SELECT name, climit, encost, abilities FROM cards WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK)
            {
                NSAssert(0,@"Error: failed to prepare statment with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
        sqlite3_bind_int (init_statement,1,pk);
        if (sqlite3_step(init_statement) == SQLITE_ROW)
        {
            NSString* str=[[NSString alloc]initWithCString:(char*) sqlite3_column_text(init_statement,0) encoding:NSASCIIStringEncoding];
            
            self.m_name = str;
            str=nil;
            
            self.m_limit = sqlite3_column_int(init_statement, 1);
            self.m_encost = sqlite3_column_int(init_statement, 2);
            
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(init_statement, 3) length:sqlite3_column_bytes(init_statement, 3)];
        
            if (data)
            {
                self.m_actions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
        }
        
        sqlite3_reset(init_statement);
    }
    return self;
}

-(void) saveToDatabase:(sqlite3 *)db
{
    if (update_statement==nil)
    {
        const char* sql = "UPDATE cards SET abilities = ? WHERE pk = ?";
        if (sqlite3_prepare_v2(db, sql, -1, &update_statement, NULL) != SQLITE_OK)
        {
//            NSAssert1(0, @"Error: failed to prepare update statement '%s' .", sqlite3_errmsg(db));
        }
    }
    
    if ([NSJSONSerialization isValidJSONObject:m_actions])
    {
        sqlite3_bind_int(update_statement, 2, m_id+1);
        NSData* data = [NSJSONSerialization dataWithJSONObject:m_actions options:0 error:nil];
        
        sqlite3_bind_blob(update_statement, 1, [data bytes], (int)[data length], SQLITE_TRANSIENT);
        
        int success = sqlite3_step(update_statement);
        
        if (success != SQLITE_DONE)
        {
            NSAssert1(0, @"Error: failed to update '%s' .", sqlite3_errmsg(db));
        }
        
        data = nil;
    }
    
    sqlite3_reset(update_statement);
}

-(void) dealloc
{
    self.m_actions = nil;
    self.m_name = nil;
}
@end
