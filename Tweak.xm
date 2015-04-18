#import <UIKit/UIKit.h>
#import <substrate.h>

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/com.joshdoctors.freeloader.plist"
#define DOCUMENT @"/Library/Application Support/FreeLoader/"
#define SETTINGSDOMAIN "com.joshdoctors.freeloader"

static BOOL enabled = NO;

static NSInteger whiteStyleSpokeCount = 12;
static NSInteger whiteStyleFPS = 30;
static NSInteger whiteStyleTheme = 0;
static BOOL whiteStyleCustomColor = NO;
static BOOL whiteStyleOptimalFPS = YES;

static NSInteger whiteLargeStyleSpokeCount = 12;
static NSInteger whiteLargeStyleFPS = 30;
static NSInteger whiteLargeStyleTheme = 0;
static BOOL whiteLargeStyleCustomColor = NO;
static BOOL whiteLargeStyleOptimalFPS = YES;

static NSInteger grayStyleSpokeCount = 12;
static NSInteger grayStyleFPS = 30;
static NSInteger grayStyleTheme = 0;
static BOOL grayStyleCustomColor = NO;
static BOOL grayStyleOptimalFPS = YES;

static NSInteger statusBarStyleSpokeCount = 8;
static NSInteger statusBarStyleFPS = 30;
static NSInteger statusBarStyleTheme = 0;
static BOOL statusBarStyleCustomColor = NO;
static BOOL statusBarStyleOptimalFPS = YES;

static NSInteger _style;

static bool isNumeric(NSString* input)
{
	if(!input)
		return NO;

    return [[NSScanner scannerWithString:input] scanFloat:NULL];
}

static void loadPrefs() 
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];

	NSNumber * temp = prefs[@"enabled"];
	enabled = temp ? [temp boolValue] : 0;

	temp = prefs[@"whiteStyleSpokeCount"];
	whiteStyleSpokeCount = temp ? [temp intValue] : 12;
    whiteStyleSpokeCount = whiteStyleSpokeCount > 0 ? whiteStyleSpokeCount : 1;
	temp = prefs[@"whiteStyleFPS"];
	whiteStyleFPS = temp ? [temp intValue] : 30;
    whiteStyleFPS = whiteStyleFPS > 0 ? whiteStyleFPS : 30;
	temp = prefs[@"whiteStyleTheme"];
	whiteStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"whiteStyleCustomColor"];
	whiteStyleCustomColor = temp ? [temp boolValue] : 0;
    temp = prefs[@"whiteStyleOptimalFPS"];
    whiteStyleOptimalFPS = temp ? [temp boolValue] : 1;

	temp = prefs[@"whiteLargeStyleSpokeCount"];
	whiteLargeStyleSpokeCount = temp ? [temp intValue] : 12;
    whiteLargeStyleSpokeCount = whiteLargeStyleSpokeCount > 0 ? whiteLargeStyleSpokeCount : 1;
	temp = prefs[@"whiteLargeStyleFPS"];
	whiteLargeStyleFPS = temp ? [temp intValue] : 30;
    whiteLargeStyleFPS = whiteLargeStyleFPS > 0 ? whiteLargeStyleFPS : 30;
	temp = prefs[@"whiteLargeStyleTheme"];
	whiteLargeStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"whiteLargeStyleCustomColor"];
	whiteLargeStyleCustomColor = temp ? [temp boolValue] : 0;
    temp = prefs[@"whiteLargeStyleOptimalFPS"];
    whiteLargeStyleOptimalFPS = temp ? [temp boolValue] : 1;

	temp = prefs[@"grayStyleSpokeCount"];
	grayStyleSpokeCount = temp ? [temp intValue] : 12;
    grayStyleSpokeCount = grayStyleSpokeCount > 0 ? grayStyleSpokeCount : 1;
	temp = prefs[@"grayStyleFPS"];
	grayStyleFPS = temp ? [temp intValue] : 30;
    grayStyleFPS = grayStyleFPS > 0 ? grayStyleFPS : 30;
	temp = prefs[@"grayStyleTheme"];
	grayStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"grayStyleCustomColor"];
	grayStyleCustomColor = temp ? [temp boolValue] : 0;
    temp = prefs[@"grayStyleOptimalFPS"];
    grayStyleOptimalFPS = temp ? [temp boolValue] : 1;

	temp = prefs[@"statusBarStyleSpokeCount"];
	statusBarStyleSpokeCount = temp ? [temp intValue] : 8;
    statusBarStyleSpokeCount = statusBarStyleSpokeCount > 0 ? statusBarStyleSpokeCount : 1;
	temp = prefs[@"statusBarStyleFPS"];
	statusBarStyleFPS = temp ? [temp intValue] : 30;
    statusBarStyleFPS = statusBarStyleFPS > 0 ? statusBarStyleFPS : 30;
	temp = prefs[@"statusBarStyleTheme"];
	statusBarStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"statusBarStyleCustomColor"];
	statusBarStyleCustomColor = temp ? [temp boolValue] : 0;
    temp = prefs[@"statusBarStyleOptimalFPS"];
    statusBarStyleOptimalFPS = temp ? [temp boolValue] : 1;

	NSLog(@"[FreeLoader]Prefs have changed: %d", enabled);
	NSLog(@"%ld %f %ld %d %d", whiteStyleSpokeCount, whiteStyleFPS, whiteStyleTheme, whiteStyleCustomColor, whiteStyleOptimalFPS);
	NSLog(@"%ld %f %ld %d %d", whiteLargeStyleSpokeCount, whiteLargeStyleFPS, whiteLargeStyleTheme, whiteLargeStyleCustomColor, whiteLargeStyleOptimalFPS);
	NSLog(@"%ld %f %ld %d %d", grayStyleSpokeCount, grayStyleFPS, grayStyleTheme, grayStyleCustomColor, grayStyleOptimalFPS);
	NSLog(@"%ld %f %ld %d %d", statusBarStyleSpokeCount, statusBarStyleFPS, statusBarStyleTheme, statusBarStyleCustomColor, statusBarStyleOptimalFPS);
}

%hook UIActivityIndicatorView

%new - (double)getAnimationDuration{
    double _duration = MSHookIvar<double>(self, "_duration");
	return _duration;
}

- (bool)_hasCustomColor
{ 
//	%log;

	bool orig = %orig;

	if(enabled)
	{
		_style = [self activityIndicatorViewStyle];

		if(_style == 0)
	    {
	        return whiteLargeStyleCustomColor;
	    }
	    else if(_style == 1)
	    {
	        return whiteStyleCustomColor;
	    }
	    else if(_style == 2)
	    {
	        return grayStyleCustomColor;
	    }
	    else if(_style == 6)
	    {
	        return statusBarStyleCustomColor;
	    }
	    else
	    	return orig;
	}
	else
		return orig;
}

/*
-(void)setAnimationDuration:(double)duration
{
//	%log;

	if(enabled)
	{
		_style = [self activityIndicatorViewStyle];

		if(_style == 0)
	    {
	       %orig((double)whiteLargeStyleSpokeCount/(whiteLargeStyleFPS*1.0));
	    }
	    else if(_style == 1)
	    {
	       %orig((double)whiteStyleSpokeCount/(whiteStyleFPS*1.0));
	    }
	    else if(_style == 2)
	    {
        NSLog(@"count: %d", grayStyleSpokeCount);
        NSLog(@"FPS: %d", grayStyleFPS);
        NSLog(@"dur: %ld",(long) grayStyleSpokeCount/(grayStyleFPS*1.0));
        long double test =  (grayStyleSpokeCount*1.0)/(grayStyleFPS*1.0);
        NSLog(@"test: %Lg", test);
	       %orig(test);
	    }
	    else if(_style == 6)
	    {
	       %orig((double)statusBarStyleSpokeCount/(statusBarStyleFPS*1.0));
	    }
	    else
	    {
	    	//NSLog(@"Style was not known, using original speed");
	    	%orig;
	    }
	}
	else
		%orig;
}*/

 %new -(void)setAnimationDuration
{
    _style = [self activityIndicatorViewStyle];
    long double duration;

        if(_style == 0)
        {
           duration = (whiteLargeStyleSpokeCount*1.0)/(whiteLargeStyleFPS*1.0);
        }
        else if(_style == 1)
        {
           duration = (whiteStyleSpokeCount*1.0)/(whiteStyleFPS*1.0);
        }
        else if(_style == 2)
        {
            duration =  (grayStyleSpokeCount*1.0)/(grayStyleFPS*1.0);
        }
        else if(_style == 6)
        {
           duration = (statusBarStyleSpokeCount*1.0)/(statusBarStyleFPS*1.0);
        }

        double _duration = MSHookIvar<double>(self,"_duration");
        _duration = duration;
        [self setAnimationDuration:_duration];
}

- (id)_layoutInfosForStyle:(long long)style
{
//    %log;
//    NSLog(@"%ld %f %ld %ld %f %ld %ld %f %ld %ld %f %ld", whiteStyleSpokeCount, whiteStyleFPS, whiteStyleTheme, whiteLargeStyleSpokeCount, whiteLargeStyleFPS, whiteLargeStyleTheme, grayStyleSpokeCount, grayStyleFPS, grayStyleTheme, statusBarStyleSpokeCount, statusBarStyleFPS, statusBarStyleTheme);

    NSDictionary * orig = %orig;

    if(enabled)
    {
        NSDictionary * temp = [orig mutableCopy];

        long newCount;
        _style = (long)style;

        if(_style == 0)
        {
            newCount = whiteLargeStyleSpokeCount;
        }
        else if(_style == 1)
        {
            newCount = whiteStyleSpokeCount;
        }
        else if(_style == 2)
        {
            newCount = grayStyleSpokeCount;
        }
        else if(_style == 6)
        {
            newCount = statusBarStyleSpokeCount;
        }
        else
        {
        	//Commenting the below out because we don't want to spam the user - this method is called frequently
        	//NSLog(@"Style was not known, using original count");
        	return orig;
        }

        [temp setObject:[NSNumber numberWithInt:newCount] forKey:@"spokeCount"];
        [self setAnimationDuration];
        return temp;
    }
    else
        return orig;
}

%new + (NSString*)getPathComponentFromIndex:(long)index
{
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSArray * contentsArray = [fileManager contentsOfDirectoryAtPath:DOCUMENT error:nil];

	if(index >= [contentsArray count]) //this condition is true when a user selects the default theme option.
		return nil;
	else
		return [contentsArray objectAtIndex:index];
}

+ (id)_loadResourcesForStyle:(long long)style
{ 
    //%log;
    //NSLog(@"%ld %d %ld %ld %d %ld %ld %d %ld %ld %d %ld", whiteStyleSpokeCount, whiteStyleFPS, whiteStyleTheme, whiteLargeStyleSpokeCount, whiteLargeStyleFPS, whiteLargeStyleTheme, grayStyleSpokeCount, grayStyleFPS, grayStyleTheme, statusBarStyleSpokeCount, statusBarStyleFPS, statusBarStyleTheme);

    id orig = %orig;

    if(enabled)
    {
       NSMutableArray *array = [NSMutableArray array];

       long newCount;
       long fileIndex;
       NSString * themePath = nil;
       _style = (long)style;

        if(_style == 0)
        {
            newCount = whiteLargeStyleSpokeCount;
            themePath = [self getPathComponentFromIndex:whiteLargeStyleTheme];
        }
        else if(_style == 1)
        {
            newCount = whiteStyleSpokeCount;
            themePath = [self getPathComponentFromIndex:whiteStyleTheme];
        }
        else if(_style == 2)
        {
            newCount = grayStyleSpokeCount;
            themePath = [self getPathComponentFromIndex:grayStyleTheme];
        }
        else if(_style == 6)
        {
            newCount = statusBarStyleSpokeCount;
            themePath = [self getPathComponentFromIndex:statusBarStyleTheme];
        }
        else
        {
        	NSLog(@"[FreeLoader]Style was not known ( %ld ), using the original images.", style);
        	return orig;
        }

        if(themePath==nil)
        	return orig;

       for (int i = 0; i < newCount; i++)
       {
            NSString *imagePath = nil;

            if(_style == 0)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/WhiteLarge.%d.png",themePath, i];
            }
            else if(_style == 1)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/White.%d.png",themePath, i];
            }
            else if(_style == 2)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/Gray.%d.png",themePath, i];
            }
            else if(_style == 6)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/StatusBar.%d.png",themePath, i];
            }

            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];

            if(image)
                [array addObject:image];
       }

       if([array count]==0)
       {
       		NSLog(@"[FreeLoader]Could not load images. Using the default images.", orig);
       		return orig;
       }
       else
       {
            NSLog(@"[FreeLoader]Loaded custom images.");
            return array;
       }
    }
    else
    {
    	NSLog(@"[FreeLoader]Using the default images.");
        return orig;
    }
}

%end

%ctor
{
	NSLog(@"Loading [FreeLoader]");
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPrefs,
                                CFSTR("com.joshdoctors.freeloader/settingschanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}