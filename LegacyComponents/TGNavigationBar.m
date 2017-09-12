#import "TGNavigationBar.h"

#import <LegacyComponents/LegacyComponents.h>

#import "LegacyComponentsInternal.h"
#import "TGColor.h"

#import "TGViewController.h"
#import "TGNavigationController.h"

#import "TGHacks.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import <CoreMotion/CoreMotion.h>

@interface TGNavigationBarLayer : CALayer

@end

@implementation TGNavigationBarLayer

@end

#pragma mark -

@interface TGFixView : UIActivityIndicatorView

@end

@implementation TGFixView

- (void)setAlpha:(CGFloat)__unused alpha
{
    [super setAlpha:0.02f];
}

@end

@implementation TGBlackNavigationBar

@end

@implementation TGWhiteNavigationBar

@end

@implementation TGTransparentNavigationBar

@end

@interface TGMusicPlayerContainerView : UIView

@end

static id<TGNavigationBarMusicPlayerProvider> _musicPlayerProvider;

@interface TGNavigationBar () <UIGestureRecognizerDelegate>
{
    bool _shouldAddBackgdropBackgroundInitialized;
    bool _shouldAddBackgdropBackground;
    
    TGMusicPlayerContainerView *_musicPlayerContainer;
    
    bool _showMusicPlayerView;
}

@property (nonatomic, strong) UIView *backgroundContainerView;
@property (nonatomic, strong) UIView *statusBarBackgroundView;

@property (nonatomic, strong) TGBackdropView *barBackgroundView;
@property (nonatomic, strong) UIView *stripeView;

@property (nonatomic) bool hiddenState;

@property (nonatomic) bool contractBackgroundContainer;

@end

@implementation TGNavigationBar

+ (void)setMusicPlayerProvider:(id<TGNavigationBarMusicPlayerProvider>)provider {
    _musicPlayerProvider = provider;
}

+ (id<TGNavigationBarMusicPlayerProvider>)musicPlayerProvider {
    return _musicPlayerProvider;
}

+ (Class)layerClass
{
    return [TGNavigationBarLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
    {
        [self commonInit:UIBarStyleDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit:[self isKindOfClass:[TGBlackNavigationBar class]] ? UIBarStyleBlackTranslucent : UIBarStyleDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame barStyle:(UIBarStyle)barStyle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit:barStyle];
    }
    return self;
}

- (void)commonInit:(UIBarStyle)barStyle
{
    if (iosMajorVersion() >= 7 && [TGViewController isWidescreen] && [CMMotionActivityManager isActivityAvailable])
    {
        TGFixView *activityIndicator = [[TGFixView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 0.02f;
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    
    CGFloat backgroundOverflow = iosMajorVersion() >= 7 ? 20.0f : 0.0f;
    
    if (![self isKindOfClass:[TGTransparentNavigationBar class]])
    {
        _backgroundContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, -backgroundOverflow, self.bounds.size.width, backgroundOverflow + self.bounds.size.height)];
        _backgroundContainerView.userInteractionEnabled = false;
        [super insertSubview:_backgroundContainerView atIndex:0];
        
        _barBackgroundView = [TGBackdropView viewWithLightNavigationBarStyle];
        if ([self isKindOfClass:[TGWhiteNavigationBar class]])
            _barBackgroundView.backgroundColor = [UIColor whiteColor];
        _barBackgroundView.frame = _backgroundContainerView.bounds;
        [_backgroundContainerView addSubview:_barBackgroundView];
        
        if (barStyle == UIBarStyleDefault)
        {
            _stripeView = [[UIView alloc] init];
            _stripeView.backgroundColor = UIColorRGB(0xb2b2b2);
            [_backgroundContainerView addSubview:_stripeView];
        }
    }
    
    if (barStyle == UIBarStyleDefault)
    {
        self.tintColor = TGAccentColor();
    }
    
    if (iosMajorVersion() < 7)
    {
        _contractBackgroundContainer = true;
        _progressView = [[UIView alloc] init];
        
        self.translucent = true;
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setBackgroundColor:(UIColor *)__unused backgroundColor
{
    static UIColor *clearColor = nil;
    if (clearColor == nil)
        clearColor = [UIColor clearColor];
    [super setBackgroundColor:clearColor];
}

- (void)dealloc
{
}

- (void)layoutSubviews
{
    if (_backgroundContainerView != nil)
    {
        CGFloat backgroundOverflow = iosMajorVersion() >= 7 ? 20.0f : 0.0f;
        _backgroundContainerView.frame = CGRectMake(0, -backgroundOverflow, self.bounds.size.width, backgroundOverflow + self.bounds.size.height);
        
        if (_barBackgroundView != nil)
            _barBackgroundView.frame = _backgroundContainerView.bounds;
    }
    
    if (_stripeView != nil)
    {
        CGFloat stripeHeight = TGScreenPixel;
        _stripeView.frame = CGRectMake(0, _backgroundContainerView.bounds.size.height - stripeHeight, _backgroundContainerView.bounds.size.width, stripeHeight);
    }
    
    [super layoutSubviews];
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    [self setBarStyle:barStyle animated:false];
}

- (void)setBarStyle:(UIBarStyle)__unused barStyle animated:(bool)__unused animated
{
    if (iosMajorVersion() < 7)
    {
        if (self.barStyle != UIBarStyleBlackTranslucent || barStyle != UIBarStyleBlackTranslucent)
            barStyle = UIBarStyleBlackTranslucent;
    }
    
    [super setBarStyle:barStyle];
}

- (void)setBarStyle:(UIBarStyle)barStyle animated:(bool)animated duration:(NSTimeInterval)duration
{
    UIBarStyle previousBarStyle = self.barStyle;
    
    if (previousBarStyle != barStyle)
        [self updateBarStyle:barStyle previousBarStyle:previousBarStyle animated:animated duration:duration];
    
    [super setBarStyle:barStyle];
}

- (void)resetBarStyle
{
}

- (void)setCenter:(CGPoint)center
{    
    bool shouldFix = (iosMajorVersion() >= 7);
    if (shouldFix)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            static Class fixClassName = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                fixClassName = NSClassFromString(@"TGTabletMainView");
            });
            if (fixClassName != nil) {
                shouldFix = [[[[self superview] superview] superview] isKindOfClass:[fixClassName class]];
            }
        }
    }
    
    if (shouldFix && center.y <= self.frame.size.height / 2)
        center.y = center.y + 20.0f;
    
    center.y += self.verticalOffset;
    
    [super setCenter:center];
    
    if (_statusBarBackgroundView != nil && _statusBarBackgroundView.superview != nil)
    {
        _statusBarBackgroundView.frame = CGRectMake(0, -self.frame.origin.y, self.frame.size.width, 20);
    }
    
    _musicPlayerContainer.alpha = center.y < 0.0f ? 0.0f : 1.0f;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_statusBarBackgroundView != nil && _statusBarBackgroundView.superview != nil)
    {
        _statusBarBackgroundView.frame = CGRectMake(0, -self.frame.origin.y, self.frame.size.width, 20);
    }
    
    _musicPlayerContainer.alpha = frame.origin.y < 0.0f ? 0.0f : 1.0f;
    _musicPlayerContainer.frame = CGRectMake(0.0f, frame.size.height + self.musicPlayerOffset, frame.size.width, 37.0f);
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    _musicPlayerContainer.frame = CGRectMake(0.0f, bounds.size.height + self.musicPlayerOffset, bounds.size.width, 37.0f);
}

- (void)setHiddenState:(bool)hidden animated:(bool)animated
{
    if (animated)
    {
        if (_hiddenState != hidden)
        {
            if (iosMajorVersion() < 7)
            {
                _hiddenState = hidden;
                
                if (_statusBarBackgroundView == nil)
                {
                    _statusBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.origin.y, self.frame.size.width, 20)];
                    _statusBarBackgroundView.backgroundColor = [UIColor blackColor];
                }
                else
                    _statusBarBackgroundView.frame = CGRectMake(0, -self.frame.origin.y, self.frame.size.width, 20);
                
                [self addSubview:_statusBarBackgroundView];
                
                [UIView animateWithDuration:0.3 animations:^
                 {
                     _progressView.alpha = hidden ? 0.0f : 1.0f;
                 } completion:^(BOOL finished)
                 {
                     if (finished)
                         [_statusBarBackgroundView removeFromSuperview];
                 }];
            }
        }
        else
        {
            _progressView.alpha = hidden ? 0.0f : 1.0f;
        }
    }
    else
    {
        _hiddenState = hidden;
        
        _progressView.alpha = hidden ? 0.0f : 1.0f;
    }
}

- (UIView *)findBackground:(UIView *)view
{
    if (view == nil)
        return nil;
    
    NSString *viewClass = NSStringFromClass([view class]);
    if ([viewClass isEqualToString:@"_UINavigationBarBackground"] || [viewClass isEqualToString:@"_UIBarBackground"])
        return view;
    
    for (UIView *subview in view.subviews)
    {
        UIView *result = [self findBackground:subview];
        if (result != nil)
            return result;
    }
    
    return nil;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (!hidden)
    {
        UIView *backgroundView = [self findBackground:self];
        backgroundView.hidden = true;
        [backgroundView removeFromSuperview];
    }
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    if (view != self.additionalView)
        [super insertSubview:view atIndex:MIN((int)self.subviews.count, MAX(index, 2))];
    else
        [super insertSubview:view atIndex:index];
}

- (bool)shouldAddBackdropBackground
{
    if (!_shouldAddBackgdropBackgroundInitialized)
    {
        _shouldAddBackgdropBackground = false;
        _shouldAddBackgdropBackgroundInitialized = true;
    }
    
    return _shouldAddBackgdropBackground;
}

- (unsigned int)indexAboveBackdropBackground
{
    if ([self shouldAddBackdropBackground])
    {
        static unsigned int (*nativeImpl)(id, SEL) = NULL;
        static SEL nativeSelector = NULL;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^
        {
            freedomImpl(self, 0xc6dda86U, &nativeSelector);
            if (nativeSelector != NULL)
                nativeImpl = (unsigned int (*)(id, SEL))freedomNativeImpl(object_getClass(self), nativeSelector);
        });
        
        if (nativeImpl != NULL)
            return nativeImpl(self, nativeSelector);
    }

    return 1;
}

- (void)updateBarStyle:(UIBarStyle)__unused barStyle previousBarStyle:(UIBarStyle)__unused previousBarStyle animated:(bool)__unused animated duration:(NSTimeInterval)__unused duration
{
}

#pragma mark -

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint point = [recognizer locationInView:self];
        
        if (point.x >= 100 && point.x < self.frame.size.width - 100)
        {
            __strong UINavigationController *navigationController = _navigationController;
            UIViewController *viewController = navigationController.topViewController;
            if ([viewController conformsToProtocol:@protocol(TGViewControllerNavigationBarAppearance)] && [viewController respondsToSelector:@selector(navigationBarAction)])
            {
                [(id<TGViewControllerNavigationBarAppearance>)viewController navigationBarAction];
            }
        }
    }
}

- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        __strong UINavigationController *navigationController = _navigationController;
        UIViewController *viewController = navigationController.topViewController;
        if ([viewController conformsToProtocol:@protocol(TGViewControllerNavigationBarAppearance)] && [viewController respondsToSelector:@selector(navigationBarSwipeDownAction)])
        {
            [(id<TGViewControllerNavigationBarAppearance>)viewController navigationBarSwipeDownAction];
        }
    }
}

- (CGRect)musicPlayerFrameForContainerSize:(CGSize)containerSize
{
    return CGRectMake(0.0f, _minimizedMusicPlayer ? -34.0f : 0.0f, containerSize.width, containerSize.height);
}

- (void)showMusicPlayerView:(bool)show animation:(void (^)())animation
{
    _showMusicPlayerView = show;
    if (show)
    {
        if (_musicPlayerContainer == nil)
        {
            _musicPlayerContainer = [[TGMusicPlayerContainerView alloc] init];
            _musicPlayerContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _musicPlayerContainer.frame = CGRectMake(0.0f, self.frame.size.height + self.musicPlayerOffset, self.frame.size.width, 37.0f);
            
            _musicPlayerView = [_musicPlayerProvider makeMusicPlayerView:_navigationController];
            if (_musicPlayerView != nil) {
                _musicPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                _musicPlayerView.frame = CGRectOffset(_musicPlayerContainer.bounds, 0.0f, -_musicPlayerContainer.frame.size.height);
                [_musicPlayerContainer addSubview:_musicPlayerView];
                [self addSubview:_musicPlayerContainer];
            }
        }
        _musicPlayerContainer.clipsToBounds = true;
        _musicPlayerContainer.userInteractionEnabled = true;
        [UIView animateWithDuration:0.3 delay:0.0 options:7 << 16 animations:^
        {
            _musicPlayerView.frame = [self musicPlayerFrameForContainerSize:_musicPlayerContainer.bounds.size];
            
            if (animation)
                animation();
        } completion:^(BOOL finished){
            if (finished)
                _musicPlayerContainer.clipsToBounds = false;
        }];
    }
    else if (_musicPlayerView != nil)
    {
        _musicPlayerContainer.clipsToBounds = true;
        _musicPlayerContainer.userInteractionEnabled = false;
        [UIView animateWithDuration:0.3 delay:0.0 options:7 << 16 animations:^
        {
            _musicPlayerView.frame = CGRectOffset(_musicPlayerContainer.bounds, 0.0f, -_musicPlayerContainer.frame.size.height);
            if (animation)
                animation();
        } completion:nil];
    }
}

- (void)setMusicPlayerOffset:(CGFloat)musicPlayerOffset
{
    _musicPlayerOffset = musicPlayerOffset;
    _musicPlayerContainer.frame = CGRectMake(0.0f, self.frame.size.height + self.musicPlayerOffset, self.frame.size.width, 37.0f);
}

- (void)setMinimizedMusicPlayer:(bool)minimizedMusicPlayer
{
    if (_minimizedMusicPlayer != minimizedMusicPlayer)
    {
        _minimizedMusicPlayer = minimizedMusicPlayer;
        if (_showMusicPlayerView)
        {
            [UIView animateWithDuration:0.25 delay:0.0 options:7 << 16 animations:^
            {
                _musicPlayerView.frame = [self musicPlayerFrameForContainerSize:_musicPlayerContainer.bounds.size];
            } completion:nil];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [_musicPlayerContainer hitTest:CGPointMake(point.x - _musicPlayerContainer.frame.origin.x, point.y - _musicPlayerContainer.frame.origin.y) withEvent:event];
    if (result != nil && self.alpha > FLT_EPSILON)
        return result;
    
    if (self.additionalView != nil)
    {
        UIView *result = [self.additionalView hitTest:CGPointMake(point.x - self.additionalView.frame.origin.x, point.y - self.additionalView.frame.origin.y) withEvent:event];
        if (result != nil)
            return result;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)setAlpha:(CGFloat)alpha {
    if (!_keepAlpha) {
        [super setAlpha:alpha];
    }
}

@end


@implementation TGMusicPlayerContainerView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.subviews.firstObject pointInside:[self convertPoint:point toView:self.subviews.firstObject] withEvent:event];
}

@end
