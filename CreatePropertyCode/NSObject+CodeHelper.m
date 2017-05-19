//
//  NSObject+CodeHelper.m
//  CreatePropertyCode
//
//  Created by 贺瑞 on 2017/5/18.
//  Copyright © 2017年 ifensi. All rights reserved.
//

#import "NSObject+CodeHelper.h"

@implementation NSObject (CodeHelper)

NSString *className;
NSString *baseClassName;

- (void)setBaseClasName:(NSString *)baseClasName
{
    baseClassName = baseClasName;
}

- (void)createPropertyCode
{
    if(!baseClassName) baseClassName = @"ActivityList";
    if(!className) className = baseClassName;
    
    if([self isKindOfClass:[NSArray class]]){
        [[(NSArray *)self firstObject] createPropertyCode];

    } else if([self isKindOfClass:[NSDictionary class]]){
        
        NSMutableString *hCodes = [NSMutableString string];
        NSMutableString *mCodes = [NSMutableString string];




        [hCodes appendFormat:@"\n@interface %@ : NSObject\n", className];
        [mCodes appendFormat:@"\n@implementation %@\n", className];

        
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull val, BOOL * _Nonnull stop) {
            
            
            NSString *code;
            if([val isKindOfClass:[NSString class]]){
                code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;", key];
                
            }else if([val isKindOfClass:[NSNumber class]]){
                code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;", key];

            }else if([val isKindOfClass:[NSArray class]]){
                className = [NSString stringWithFormat:@"%@%@", baseClassName, [key capitalizedString]];

                code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray<%@ *> *%@;", className, key];
                [[(NSArray *)val firstObject] createPropertyCode];
            }
            
            [hCodes appendFormat:@"\n%@\n", code];
        }];
        
        [hCodes appendFormat:@"\n@end\n"];
        [mCodes appendFormat:@"\n@end\n"];

        
        [self writeFile:hCodes Path:[self filePathWithExt:@"h"]];
        [self writeFile:mCodes Path:[self filePathWithExt:@"m"]];

    }
    
}



- (void)writeFile:(NSString *)string Path:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]){
        if(![fileManager createFileAtPath:filePath contents:nil attributes:nil]){
            NSLog(@"创建文件失败！！！");
            return;
        }else{
            //创建文件成功
            if([filePath hasSuffix:@".h"]){
                string = [NSString stringWithFormat:@"#import <Foundation/Foundation.h>\n%@", string];
                
            } else if([filePath hasSuffix:@".m"]){
                NSString *fileName = [self fileNameWithExt:@"h"];
                string = [NSString stringWithFormat:@"#import \"%@\"\n%@", fileName, string];
            }
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];//将节点跳到文件的末尾
    [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]]; //追加写入数据
    [fileHandle closeFile];
}

- (NSString *)filePathWithExt:(NSString *)ext
{
    NSString *fileName = [self fileNameWithExt:ext];
    return [NSHomeDirectory() stringByAppendingPathComponent:fileName];
}
- (NSString *)fileNameWithExt:(NSString *)ext
{
   return [NSString stringWithFormat:@"%@.%@", baseClassName, ext];
}


- (void)clear
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self filePathWithExt:@"h"] error:NULL];
    [fileManager removeItemAtPath:[self filePathWithExt:@"m"] error:NULL];

    className = nil;
    baseClassName = nil;
}

@end
