#import <UIKit/UIKit.h>
#import <substrate.h>

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/com.joshdoctors.freeloader.plist"
#define DOCUMENT @"/Library/Application Support/FreeLoader/"
#define SETTINGSDOMAIN "com.joshdoctors.freeloader"

static BOOL enabled = NO;

static NSInteger whiteStyleSpokeCount = 12;
static CGFloat whiteStyleSpeed = 1;
static NSInteger whiteStyleTheme = 0;
static BOOL whiteStyleCustomColor = NO;

static NSInteger whiteLargeStyleSpokeCount = 12;
static CGFloat whiteLargeStyleSpeed = 1;
static NSInteger whiteLargeStyleTheme = 0;
static BOOL whiteLargeStyleCustomColor = NO;

static NSInteger grayStyleSpokeCount = 12;
static CGFloat grayStyleSpeed = 1;
static NSInteger grayStyleTheme = 0;
static BOOL grayStyleCustomColor = NO;

static NSInteger statusBarStyleSpokeCount = 8;
static CGFloat statusBarStyleSpeed = 1;
static NSInteger statusBarStyleTheme = 0;
static BOOL statusBarStyleCustomColor = NO;

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
	temp = prefs[@"whiteStyleSpeed"];
	whiteStyleSpeed = temp ? [temp floatValue] : 1.0;
	temp = prefs[@"whiteStyleTheme"];
	whiteStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"whiteStyleCustomColor"];
	whiteStyleCustomColor = temp ? [temp boolValue] : 0;

	temp = prefs[@"whiteLargeStyleSpokeCount"];
	whiteLargeStyleSpokeCount = temp ? [temp intValue] : 12;
	temp = prefs[@"whiteLargeStyleSpeed"];
	whiteLargeStyleSpeed = temp ? [temp floatValue] : 1.0;
	temp = prefs[@"whiteLargeStyleTheme"];
	whiteLargeStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"whiteLargeStyleCustomColor"];
	whiteLargeStyleCustomColor = temp ? [temp boolValue] : 0;

	temp = prefs[@"grayStyleSpokeCount"];
	grayStyleSpokeCount = temp ? [temp intValue] : 12;
	temp = prefs[@"grayStyleSpeed"];
	grayStyleSpeed = temp ? [temp floatValue] : 1.0;
	temp = prefs[@"grayStyleTheme"];
	grayStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"grayStyleCustomColor"];
	grayStyleCustomColor = temp ? [temp boolValue] : 0;

	temp = prefs[@"statusBarStyleSpokeCount"];
	statusBarStyleSpokeCount = temp ? [temp intValue] : 8;
	temp = prefs[@"statusBarStyleSpeed"];
	statusBarStyleSpeed = temp ? [temp floatValue] : 1.0;
	temp = prefs[@"statusBarStyleTheme"];
	statusBarStyleTheme = temp ? [temp intValue] : 0;
	temp = prefs[@"statusBarStyleCustomColor"];
	statusBarStyleCustomColor = temp ? [temp boolValue] : 0;

	NSLog(@"[FreeLoader]Prefs have changed: %d", enabled);
	NSLog(@"%ld %f %ld %d", whiteStyleSpokeCount, whiteStyleSpeed, whiteStyleTheme, whiteStyleCustomColor);
	NSLog(@"%ld %f %ld %d", whiteLargeStyleSpokeCount, whiteLargeStyleSpeed, whiteLargeStyleTheme, whiteLargeStyleCustomColor);
	NSLog(@"%ld %f %ld %d", grayStyleSpokeCount, grayStyleSpeed, grayStyleTheme, grayStyleCustomColor);
	NSLog(@"%ld %f %ld %d", statusBarStyleSpokeCount, statusBarStyleSpeed, statusBarStyleTheme, statusBarStyleCustomColor);
}

%hook UIActivityIndicatorView

%new - (CGFloat)getAnimationDuration{
	return MSHookIvar<CGFloat>(self, "_duration");
}

- (bool)_hasCustomColor
{ 
//	%log;

	bool orig = %orig;

	if(enabled)
	{
		long style = [self activityIndicatorViewStyle];

		if(style == 0)
	    {
	        return whiteLargeStyleCustomColor;
	    }
	    else if(style == 1)
	    {
	        return whiteStyleCustomColor;
	    }
	    else if(style == 2)
	    {
	        return grayStyleCustomColor;
	    }
	    else if(style == 6)
	    {
	        return statusBarStyleCustomColor;
	    }
	    else
	    	return orig;
	}
	else
		return orig;
}

-(void)setAnimationDuration:(CGFloat)duration
{
//	%log;

	if(enabled)
	{
		long style = [self activityIndicatorViewStyle];

		if(style == 0)
	    {
	        %orig(whiteLargeStyleSpeed);
	    }
	    else if(style == 1)
	    {
	        %orig(whiteStyleSpeed);
	    }
	    else if(style == 2)
	    {
	        %orig(grayStyleSpeed);
	    }
	    else if(style == 6)
	    {
	        %orig(statusBarStyleSpeed);
	    }
	    else
	    {
	    	//NSLog(@"Style was not known, using original speed");
	    	%orig;
	    }
	}
	else
		%orig;
}

- (id)_layoutInfosForStyle:(long long)style
{
//    %log;
//    NSLog(@"%ld %f %ld %ld %f %ld %ld %f %ld %ld %f %ld", whiteStyleSpokeCount, whiteStyleSpeed, whiteStyleTheme, whiteLargeStyleSpokeCount, whiteLargeStyleSpeed, whiteLargeStyleTheme, grayStyleSpokeCount, grayStyleSpeed, grayStyleTheme, statusBarStyleSpokeCount, statusBarStyleSpeed, statusBarStyleTheme);

    NSDictionary * orig = %orig;

    if(enabled)
    {
        NSDictionary * temp = [orig mutableCopy];

        long newCount;

        if(style == 0)
        {
            newCount = whiteLargeStyleSpokeCount;
        }
        else if(style == 1)
        {
            newCount = whiteStyleSpokeCount;
        }
        else if(style == 2)
        {
            newCount = grayStyleSpokeCount;
        }
        else if(style == 6)
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
        [self setAnimationDuration:style];
        return temp;
    }
    else
        return orig;
}

%new + (NSString*)getPathComponentFromIndex:(long)index
{
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSArray * contentsArray = [fileManager contentsOfDirectoryAtPath:DOCUMENT error:nil];
	return [contentsArray objectAtIndex:index];
}

+ (id)_loadResourcesForStyle:(long long)style
{ 
//    %log;
//    NSLog(@"%ld %f %ld %ld %f %ld %ld %f %ld %ld %f %ld", whiteStyleSpokeCount, whiteStyleSpeed, whiteStyleTheme, whiteLargeStyleSpokeCount, whiteLargeStyleSpeed, whiteLargeStyleTheme, grayStyleSpokeCount, grayStyleSpeed, grayStyleTheme, statusBarStyleSpokeCount, statusBarStyleSpeed, statusBarStyleTheme);

    id orig = %orig;

    if(enabled)
    {
       NSMutableArray *array = [NSMutableArray array];

       long newCount;
       long fileIndex;

        if(style == 0)
        {
            newCount = whiteLargeStyleSpokeCount;
            fileIndex = whiteLargeStyleTheme;
        }
        else if(style == 1)
        {
            newCount = whiteStyleSpokeCount;
            fileIndex = whiteStyleTheme;
        }
        else if(style == 2)
        {
            newCount = grayStyleSpokeCount;
            fileIndex = grayStyleTheme;
        }
        else if(style == 6)
        {
            newCount = statusBarStyleSpokeCount;
            fileIndex = statusBarStyleTheme;
        }
        else
        {
        	NSLog(@"[FreeLoader]Style was not known ( %ld ), using the original images.", style);
        	return orig;
        }

       for (int i = 0; i < newCount; i++)
       {
            NSString *imagePath = nil;

            if(style == 0)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/UIActivityIndicatorViewStyleWhiteLarge.%d.png",[self getPathComponentFromIndex:fileIndex], i];
            }
            else if(style == 1)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/UIActivityIndicatorViewStyleWhite.%d.png",[self getPathComponentFromIndex:fileIndex], i];
            }
            else if(style == 2)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/UIActivityIndicatorViewStyleGray.%d.png",[self getPathComponentFromIndex:fileIndex], i];
            }
            else if(style == 6)
            {
                imagePath = [NSString stringWithFormat:@"/Library/Application Support/FreeLoader/%@/UIActivityIndicatorViewStyleStatusBar.%d.png",[self getPathComponentFromIndex:fileIndex], i];
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