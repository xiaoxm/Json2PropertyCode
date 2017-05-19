//
//  ViewController.m
//  CreatePropertyCode
//
//  Created by 贺瑞 on 2017/5/18.
//  Copyright © 2017年 ifensi. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+CodeHelper.h"

@interface ViewController()<NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;
@property (weak) IBOutlet NSTextField *baseClasNameTF;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (IBAction)createBtnOnclick:(NSButton *)sender {
    
    if(!_jsonTextView.textStorage.string.length) return;
    
    NSData *data = [_jsonTextView.textStorage.string dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    if(!result) return;
    
    NSString *baseClasName = _baseClasNameTF.stringValue.length ? _baseClasNameTF.stringValue : @"Model";
    [result setBaseClasName:baseClasName];
    [result createPropertyCode];

    
    NSArray *urls = @[[NSURL fileURLWithPath:[result filePathWithExt:@"h"]],
                       [NSURL fileURLWithPath:[result filePathWithExt:@"m"]]];
    
//    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
    
    
    
    NSString *filePath = [result filePathWithExt:@"h"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    NSData *codeData = [fileHandle readDataToEndOfFile];
    NSString *code = [[NSString alloc] initWithData:codeData encoding:NSUTF8StringEncoding];
    
    
    NSRange range = NSMakeRange (0, [_codeTextView.textStorage.string length]);
    [_codeTextView replaceCharactersInRange: range withString: code];
    
    
    [result clear];
    
 
}






@end
