//
//  MarkupTextStorage.m
//  TextKitDemo
//
//  Created by shawn on 2017/9/11.
//  Copyright © 2017年 shawn. All rights reserved.
//

#import "MarkupTextStorage.h"

@implementation MarkupTextStorage
{
    NSMutableAttributedString *_backingStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc] init];
    }
    return self;
}


- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
           range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes
           range:range changeInLength:0];
    [self endEditing];
}
@end
