//
//  Common.h
//  测试
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 王永军. All rights reserved.
//

#ifndef Common_h
#define Common_h


#endif /* Common_h */


// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MYLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MYLog(...)
#endif


#if  defined  (DEBUG)  &&  DEBUG  ==  1
#else
#define  NSLog(...)  {};
#endif