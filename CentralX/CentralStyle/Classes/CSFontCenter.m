//
//  CSFontCenter.m
//  AYStyle
//
//  Created by Alan Yeh on 16/8/2.
//
//

#import "CSFontCenter.h"
#import <CentralX/CentralRuntime.h>

static NSString *AYCurrentFontNameKey = @"AYCurrentFontNameKey";
static NSString *AYCurrentFontLevelKey = @"AYCurrentFontLevelKey";

@implementation CSFontCenter{
    NSString *_currentFontName;
    CSFontLevel _currentLevel;
    NSHashTable *_observers;
}
- (NSInteger)increasementForLevel:(CSFontLevel)level{
    if (level == CSFontLevelSystem) {
        NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
        if (contentSize == UIContentSizeCategoryExtraSmall || contentSize == UIContentSizeCategorySmall) {
            level = CSFontLevelSmall;
        }else if (contentSize == UIContentSizeCategoryMedium){
            level = CSFontLevelMedium;
        }else if (contentSize == UIContentSizeCategoryLarge){
            level = CSFontLevelLarge;
        }else if (contentSize == UIContentSizeCategoryExtraLarge){
            level = CSFontLevelExtralLarge;
        }else{
            level = CSFontLevelExtralExtralLarge;
        }
    }
    
    switch (level) {
        case CSFontLevelSmall:
            return -2;
        case CSFontLevelMedium:
            return 0;
        case CSFontLevelLarge:
            return 2;
        case CSFontLevelExtralLarge:
            return 4;
        case CSFontLevelExtralExtralLarge:
            return 8;
        default:
            return 0;
    }
}

- (instancetype)_init{
    if (self = [super init]) {
        _observers = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

+ (instancetype)center{
    static CSFontCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSFontCenter alloc] _init];
    });
    return instance;
}

- (NSString *)currentFontName{
    return _currentFontName ?: ({
        _currentFontName = [[NSUserDefaults standardUserDefaults] objectForKey:AYCurrentFontNameKey];
        if (_currentFontName.length < 1) {
            _currentFontName = [[UIFont systemFontOfSize:10] fontName];
            [[NSUserDefaults standardUserDefaults] setObject:_currentFontName forKey:AYCurrentFontNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _currentFontName;
    });
}

- (CSFontLevel)currentFontLevel{
    return _currentLevel ?: ({
        NSNumber *currentLevel = [[NSUserDefaults standardUserDefaults] objectForKey:AYCurrentFontLevelKey];
        if (currentLevel == nil) {
            currentLevel = @(CSFontLevelSystem);
            [[NSUserDefaults standardUserDefaults] setObject:currentLevel forKey:AYCurrentFontLevelKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        currentLevel.integerValue;
    });
}

#pragma mark - 全局调整字体
- (void)applyFontName:(NSString *)fontName{
    NSParameterAssert(fontName != nil && fontName.length > 0);
    _currentFontName = [fontName copy];
    [[NSUserDefaults standardUserDefaults] setObject:_currentFontName forKey:AYCurrentFontNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<CSFontObserver> observer in self->_observers) {
            [observer loadFont:self];
        }
    });
}

- (void)applyFontLevel:(CSFontLevel)newLevel{
    _currentLevel = newLevel;
    [[NSUserDefaults standardUserDefaults] setObject:@(newLevel) forKey:AYCurrentFontLevelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<CSFontObserver> observer in self->_observers) {
            [observer loadFont:self];
        }
    });
}

- (void)applyFontLevel:(CSFontLevel)newLevel withFontName:(NSString *)fontName{
    NSParameterAssert(fontName != nil && fontName.length > 0);
    _currentLevel = newLevel;
    _currentFontName = [fontName copy];
    [[NSUserDefaults standardUserDefaults] setObject:@(newLevel) forKey:AYCurrentFontLevelKey];
    [[NSUserDefaults standardUserDefaults] setObject:_currentFontName forKey:AYCurrentFontNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<CSFontObserver> observer in self->_observers) {
            [observer loadFont:self];
        }
    });
}

#pragma mark - 调整字体相关方法
- (CGFloat)fontSizeAfterAdjust:(CGFloat)originalSize{
    return originalSize + [self increasementForLevel:self.currentFontLevel];
}

- (UIFont *)fontAfterAdjust:(UIFont *)originalFont{
    return [UIFont fontWithName:originalFont.fontName size:[self fontSizeAfterAdjust:originalFont.pointSize]];
}

- (UIFont *)fontWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:self.currentFontName size:[self fontSizeAfterAdjust:fontSize]];
}

#pragma mark - 注册与应用主题
- (void)registerObserver:(id<CSFontObserver>)observer{
    [_observers addObject:observer];
}

- (void)applyToObserver:(id<CSFontObserver>)observer{
    [observer loadFont:self];
}

- (void)autoRegisterClass:(Class)aClass beforeExecuting:(SEL)registeSEL applybeforeExecuting:(SEL)applySEL{
    //自动注册
    [CRAspect interceptSelector:registeSEL
                        inClass:aClass
                withInterceptor:CRInterceptorMake(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(CSFontObserver)]) {
            if (self.showLog) {
                NSLog(@"🅰️🅰️CSFontCenter: Auto register instance: <%@ %p>\n", [invocation.target class], invocation.target);
            }
            [[CSFontCenter center] registerObserver:invocation.target];
        }
        [invocation invoke];
    })];
    
    //自动应用字体
    [CRAspect interceptSelector:applySEL
                        inClass:aClass
                withInterceptor:CRInterceptorMake(^(NSInvocation *invocation) {
        if ([invocation.target conformsToProtocol:@protocol(CSFontObserver)]) {
            [invocation.target loadFont:[CSFontCenter center]];
        }
        [invocation invoke];
    })];
}
@end
