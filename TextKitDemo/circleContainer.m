//
//  circleContainer.m
//  TextKitDemo
//
//  Created by shawn on 2017/9/12.
//  Copyright © 2017年 shawn. All rights reserved.
//

#import "circleContainer.h"

@implementation circleContainer
- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect
                                  atIndex:(NSUInteger)characterIndex
                         writingDirection:(NSWritingDirection)baseWritingDirection
                            remainingRect:(CGRect *)remainingRect {
    
    CGRect rect = [super lineFragmentRectForProposedRect:proposedRect
                                                 atIndex:characterIndex
                                        writingDirection:baseWritingDirection
                                           remainingRect:remainingRect];
    
    CGSize size = [self size];
    CGFloat radius = fmin(size.width, size.height) / 2.0;
    CGFloat ypos = fabs((proposedRect.origin.y + proposedRect.size.height / 2.0) - radius);
    CGFloat width = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0;
    CGRect circleRect = CGRectMake(radius - width / 2.0, proposedRect.origin.y, width, proposedRect.size.height);
    
    return CGRectIntersection(rect, circleRect);
}
@end
