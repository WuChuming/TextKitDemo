//
//  ViewController.m
//  TextKitDemo
//
//  Created by shawn on 2017/9/11.
//  Copyright © 2017年 shawn. All rights reserved.
//

#import "ViewController.h"
#import "MarkupTextStorage.h"
#import "highlightString.h"
#import "circleContainer.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, copy) MarkupTextStorage *textStorage;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSTextContainer *container;

@property (nonatomic, strong) highlightString * highlightextStorage;
//自定义的view
@property (nonatomic, strong) UIView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createMarkupTextView];
//    [self createmutilayoutTextView];
//    [self createhighlightTextView];
//
    [self setCircleTextView];
}

    //演示exclusionPaths的作用
- (void)createMarkupTextView
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"textkit" ofType:@"txt"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:content
                                                                           attributes:attributes];
    _textStorage = [[MarkupTextStorage alloc] init];
    [_textStorage setAttributedString:attributedString];
    
    CGRect textViewRect = CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width-40, 200);
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake( textViewRect.size.width, CGFLOAT_MAX)];
//    textContainer.maximumNumberOfLines = 10;
    [layoutManager addTextContainer:textContainer];
    [_textStorage addLayoutManager:layoutManager];
    
    _textView = [[UITextView alloc] initWithFrame:textViewRect
                                    textContainer:textContainer];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.scrollEnabled = YES;
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _container = textContainer;
    
    //演示exclusionPaths的作用
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"5"]];
    imageView.center = CGPointMake(100, 100);
    CGRect ofram = [self.textView convertRect:imageView.bounds fromView:imageView];
    ofram.origin.y = ofram.origin.y;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:ofram];
    self.textView.textContainer.exclusionPaths = @[path];
    _textView.delegate = self;
    [self.view addSubview:_textView];
     [self.view addSubview:imageView];
//    [self.view addSubview:self.circleView];
}


//多layout的作用
- (void)createmutilayoutTextView
{
    NSTextStorage *sharedTextStorage = _textView.textStorage;
    [sharedTextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:@""];
    // 将一个新的 Layout Manager 附加到上面的 Text Storage 上
    NSLayoutManager *otherLayoutManager = [NSLayoutManager new];
    [sharedTextStorage addLayoutManager: otherLayoutManager];
    NSTextContainer *otherTextContainer = [NSTextContainer new];
    [otherLayoutManager addTextContainer: otherTextContainer];
    UITextView *otherTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 280, 160, 240) textContainer:otherTextContainer];
    otherTextView.translatesAutoresizingMaskIntoConstraints = YES;
    otherTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    otherTextView.scrollEnabled = NO;
    [self createmutiContainerMarkupTextViewWithLayout:otherLayoutManager];
    [self.view addSubview: otherTextView];
}


//多容器的作用
- (void)createmutiContainerMarkupTextViewWithLayout:(NSLayoutManager *)manager
{
    // 将一个新的 Text Container 附加到同一个 Layout Manager，这样可以将一个文本分布到多个视图展现出来。
    NSTextContainer *thirdTextContainer = [NSTextContainer new];
    [manager addTextContainer: thirdTextContainer];
    
    UITextView *thirdTextView = [[UITextView alloc] initWithFrame:CGRectMake(200, 280, 160, 240)  textContainer:thirdTextContainer];
    thirdTextView.translatesAutoresizingMaskIntoConstraints = YES;
    thirdTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: thirdTextView];
}


//高亮字符串
- (void)createhighlightTextView {
    _highlightextStorage = [highlightString new];
    
    NSLayoutManager *manager  = [NSLayoutManager new];
    
    [_highlightextStorage addLayoutManager: manager];
    
    NSTextContainer *textcontainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(320, 240)];
    [manager addTextContainer:textcontainer];
    
    [_highlightextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:@"在从 Interface 文件中载入时，可以像这样将它插入文本视图,然后加 *星号* 的字就会高亮出来了"];
    
    UITextView *otherTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 550, 320, 240) textContainer:textcontainer];
    otherTextView.backgroundColor  = [UIColor yellowColor];
    otherTextView.translatesAutoresizingMaskIntoConstraints = YES;
    otherTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:otherTextView];
}



- (void)setCircleTextView{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"textkit" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSTextAlignmentJustified];
    
    NSTextStorage *text = [[NSTextStorage alloc] initWithString:string
                                                     attributes:@{
                                                                  NSParagraphStyleAttributeName: style,
                                                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]
                                                                  }];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [text addLayoutManager:layoutManager];
    
    CGRect textViewFrame = CGRectMake(20, 20, 280, 280);
    circleContainer *textContainer = [[circleContainer alloc] initWithSize:textViewFrame.size];
    [textContainer setExclusionPaths:@[ [UIBezierPath bezierPathWithOvalInRect:CGRectMake(80, 120, 50, 50)]]];
    
    [layoutManager addTextContainer:textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                               textContainer:textContainer];
    textView.allowsEditingTextAttributes = YES;
    textView.scrollEnabled = NO;
//    textView.editable = NO;
    
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----lazyLoad---
- (UIView *)circleView{
    if (!_circleView) {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 50, 80)];
        _circleView.backgroundColor = [UIColor purpleColor];
    }

    return _circleView;
}

@end
