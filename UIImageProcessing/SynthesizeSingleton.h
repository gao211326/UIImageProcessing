//
//  SynthesizeSingleton.h
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/10/27.
//  Copyright © 2016年 高磊. All rights reserved.
//

#ifndef SynthesizeSingleton_h
#define SynthesizeSingleton_h



#ifndef SYNTHESIZE_SINGLETON_FOR_CLASS

#import <objc/runtime.h>


#pragma mark Singleton

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)	\
\
+ (__CLASSNAME__*) sharedInstance;	\


#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)	\
\
static __CLASSNAME__ *instance = nil;   \
\
+ (__CLASSNAME__ *)sharedInstance{ \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{    \
        if (nil == instance){   \
            instance = [[__CLASSNAME__ alloc] init];    \
        }   \
    }); \
    \
    return instance;   \
}   \

#endif


#endif /* SynthesizeSingleton_h */
