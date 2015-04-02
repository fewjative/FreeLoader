#import <Preferences/Preferences.h>
#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>
#import <UIKit/UIKit.h>

#define kRespringAlertTag 854
#define kRespringAlertTag2 855
#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/com.joshdoctors.freeloader.plist"
#define DOCUMENT @"/Library/Application Support/FreeLoader/"
#define PREFPLIST_WHITE @"/Library/PreferenceBundles/FreeLoaderSettings.bundle/WhiteStyle.plist"
#define PREFPLIST_WHITELARGE @"/Library/PreferenceBundles/FreeLoaderSettings.bundle/WhiteLargeStyle.plist"
#define PREFPLIST_GRAY @"/Library/PreferenceBundles/FreeLoaderSettings.bundle/GrayStyle.plist"
#define PREFPLIST_STATUSBAR @"/Library/PreferenceBundles/FreeLoaderSettings.bundle/StatusBarStyle.plist"

@interface PreviewCell  : PSTableCell{
}
@end

@interface FreeLoaderSettingsListController: PSEditableListController {
}
@end

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation FreeLoaderSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"FreeLoaderSettings" target:self] retain];
	}
	[self loadDirectories];
	return _specifiers;

}

-(id)readPreferenceValue:(PSSpecifier*)specifier
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	if(!prefs[specifier.properties[@"key"]])
	{
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PREFERENCES_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost)CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//[self reload];
	//[self reloadSpecifiers];
}

-(void)respring
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Respring"
		message:@"Are you sure you want to respring?"
		delegate:self     
		cancelButtonTitle:@"No" 
		otherButtonTitles:@"Yes", nil];
	alert.tag = kRespringAlertTag;
	[alert show];
	[alert release];
}

-(void)customTheme
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DIY Custom Theme"
		message:@"We will be opening a webpage that contains the instructions, are you sure you want to continue?"
		delegate:self     
		cancelButtonTitle:@"No" 
		otherButtonTitles:@"Yes", nil];
	alert.tag = kRespringAlertTag2;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
    	if (alertView.tag == kRespringAlertTag) {
    		system("killall backboardd");
    	}
    	else if(alertView.tag == kRespringAlertTag2)
    	{
    		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.github.com/fewjative/FreeLoader"]];
    	}
    }
}

-(void)loadDirectories{

	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSMutableArray * contentsArray = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:DOCUMENT error:nil]];

	NSMutableArray * countArray = [[NSMutableArray alloc] init];

	if(contentsArray==nil)
	{
		[countArray addObject:[NSNumber numberWithInt:0]];
		contentsArray = [NSMutableArray arrayWithObjects:@"Default(No Theme)", nil];
	}
	else
	{
		[contentsArray addObject:@"Default(No Theme)"];

		for(int i=0; i < [contentsArray count]; i++)
		{
			[countArray addObject:[NSNumber numberWithInt:i]];
		}
	}

	NSMutableDictionary * plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFPLIST_WHITE];
	NSMutableArray * items  = plistDict[@"items"];
	NSMutableDictionary * subset = [items objectAtIndex:4];
	[subset setObject:contentsArray forKey:@"validTitles"];
	[subset setObject:countArray forKey:@"validValues"];
	[plistDict writeToFile:PREFPLIST_WHITE atomically:YES];

	plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFPLIST_WHITELARGE];
	items  = plistDict[@"items"];
	subset = [items objectAtIndex:4];
	[subset setObject:contentsArray forKey:@"validTitles"];
	[subset setObject:countArray forKey:@"validValues"];
	[plistDict writeToFile:PREFPLIST_WHITELARGE atomically:YES];

	plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFPLIST_GRAY];
	items  = plistDict[@"items"];
	subset = [items objectAtIndex:4];
	[subset setObject:contentsArray forKey:@"validTitles"];
	[subset setObject:countArray forKey:@"validValues"];
	[plistDict writeToFile:PREFPLIST_GRAY atomically:YES];

	plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFPLIST_STATUSBAR];
	items  = plistDict[@"items"];
	subset = [items objectAtIndex:4];
	[subset setObject:contentsArray forKey:@"validTitles"];
	[subset setObject:countArray forKey:@"validValues"];
	[plistDict writeToFile:PREFPLIST_STATUSBAR atomically:YES];

	[countArray release];
}

-(void)twitter {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/Fewjative"]];

}

-(void)save
{
    [self.view endEditing:YES];
}

-(id)_editButtonBarItem{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweet:)];
}

-(void)composeTweet:(id)sender
{
	SLComposeViewController * composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[composeController setInitialText:@"I downloaded #FreeLoader by @Fewjative and my indicators are now awesome!"];
	[self presentViewController:composeController animated:YES completion:nil];
}

@end

@interface WhiteSettingsListController: PSListController {
}
@end

@implementation WhiteSettingsListController
- (id)specifiers {
    if(_specifiers == nil) {
            _specifiers = [[self loadSpecifiersFromPlistName:@"WhiteStyle" target:self] retain];    
    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	if(!prefs[specifier.properties[@"key"]])
	{
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PREFERENCES_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost)CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)drawPreview
{
    NSArray * array = [[self view] subviews];
    UIView * view = array[0];
    array = [view subviews];
    view = array[0];
    array = [view subviews];
    view = array[6];

    if([view isKindOfClass:[PreviewCell class]])
    {
    	[view drawPreview:1];
    }
}

-(void)save
{
    [self.view endEditing:YES];
}

@end

@interface WhiteLargeSettingsListController: PSListController {
}
@end

@implementation WhiteLargeSettingsListController
- (id)specifiers {
    if(_specifiers == nil) {
     
            _specifiers = [[self loadSpecifiersFromPlistName:@"WhiteLargeStyle" target:self] retain];    

    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	if(!prefs[specifier.properties[@"key"]])
	{
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PREFERENCES_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost)CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)drawPreview
{
    NSArray * array = [[self view] subviews];
    UIView * view = array[0];
    array = [view subviews];
    view = array[0];
    array = [view subviews];
    view = array[6];

    if([view isKindOfClass:[PreviewCell class]])
    {
    	[view drawPreview:0];
    }
}

-(void)save
{
    [self.view endEditing:YES];
}

@end

@interface GraySettingsListController: PSListController {
}
@end

@implementation GraySettingsListController
- (id)specifiers {
    if(_specifiers == nil) {
     
            _specifiers = [[self loadSpecifiersFromPlistName:@"GrayStyle" target:self] retain];    

    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	if(!prefs[specifier.properties[@"key"]])
	{
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PREFERENCES_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost)CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)drawPreview
{
    NSArray * array = [[self view] subviews];
    UIView * view = array[0];
    array = [view subviews];
    view = array[0];
    array = [view subviews];
    view = array[6];

    if([view isKindOfClass:[PreviewCell class]])
    {
    	[view drawPreview:2];
    }
}

-(void)save
{
    [self.view endEditing:YES];
}

@end

@interface StatusBarSettingsListController: PSListController {
}
@end

@implementation StatusBarSettingsListController
- (id)specifiers {
    if(_specifiers == nil) {
     
            _specifiers = [[self loadSpecifiersFromPlistName:@"StatusBarStyle" target:self] retain];    

    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier
{
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	if(!prefs[specifier.properties[@"key"]])
	{
		return specifier.properties[@"default"];
	}
	return prefs[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PREFERENCES_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost)CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)drawPreview
{
    NSArray * array = [[self view] subviews];
    UIView * view = array[0];
    array = [view subviews];
    view = array[0];
    array = [view subviews];
    view = array[6];

    if([view isKindOfClass:[PreviewCell class]])
    {
    	[view drawPreview:6];
    }
}

-(void)save
{
    [self.view endEditing:YES];
}

@end

@implementation PreviewCell
-(id)initWithSpecifier:(PSSpecifier*)specifier{

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PreviewCell" specifier:specifier];

    if(self)
    {
    	[self setBackgroundColor:[UIColor clearColor]];
    	[self drawPreviewFrom:specifier];
    }

    return self;
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 80.0f;
}

-(void)drawPreviewFrom:(PSSpecifier*)specifier
{
	 if([[specifier target] isKindOfClass:[WhiteSettingsListController class]])
    {
        [self drawPreview:1];
	}
	else if([[specifier target] isKindOfClass:[WhiteLargeSettingsListController class]])
	{
        [self drawPreview:0];
	}
	else if([[specifier target] isKindOfClass:[GraySettingsListController class]])
	{
        [self drawPreview:2];
	}
	else if([[specifier target] isKindOfClass:[StatusBarSettingsListController class]])
	{
        [self drawPreview:6];
	}
}

-(void)drawPreview:(long)style
{
	NSLog(@"[FreeLoader]Drawing preview.");

	self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	
    for (UIView * subView in [self subviews]) 
    {
        if([subView isKindOfClass:[UIImageView class]])
        	[subView removeFromSuperview];
    }

    NSArray * images = [UIActivityIndicatorView _loadResourcesForStyle:style];
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    UIImageView * badIV = [[spinner subviews] objectAtIndex:0];

    CGRect rect = CGRectMake((self.frame.size.width/2.0) - (badIV.frame.size.width/2.0), (self.frame.size.height/2.0) - (badIV.frame.size.height/2.0), badIV.frame.size.width, badIV.frame.size.height);
	
    UIImageView * animationImageView = [[UIImageView alloc] initWithFrame:rect];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = [spinner getAnimationDuration];
    [self addSubview:animationImageView];
    [animationImageView startAnimating];

	[animationImageView release];
	[spinner release];
}

@end