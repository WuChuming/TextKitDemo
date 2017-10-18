//
//  highlightString.m
//  TextKitDemo
//
//  Created by shawn on 2017/9/12.
//  Copyright © 2017年 shawn. All rights reserved.
//

#import "highlightString.h"

@implementation highlightString
{
    NSMutableAttributedString *_backingStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}
//1
- (NSString *)string {
    return [_backingStore string];
}
//2
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}
//3
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@",NSStringFromRange(range), str);
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}
//4
- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing
{
    [super processEditing];
    static NSRegularExpression *expression;
    expression = expression ?: [NSRegularExpression regularExpressionWithPattern:@"(\\*\\w+(\\s\\w+)*\\*)\\s" options:0 error:NULL];
    
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    [expression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:result.range];
    }];
    
}

@end
