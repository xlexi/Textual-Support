#import "TPI_TextualSupport.h"
#import "TPI_TextualSupport_MenuController.h"
#import "TPI_TextualSupportHelper.h"

@implementation TPI_TextualSupport
NSMenu *userlistMenu;
NSMenu *inputFieldMenu;
NSDictionary *messageCacheForSupportChannel;

- (void)pluginLoadedIntoMemory {
	userlistMenu = self.menuController.userControlMenu;
    inputFieldMenu = [[mainWindow() inputTextField] menu];
    
    [self overrideExistingMenuItems];
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: @"messages" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSMenuItem *textualSupportMenuItems = [[NSMenuItem alloc] init];
	[textualSupportMenuItems setTitle:@"Textual Support"];
	[textualSupportMenuItems setKeyEquivalent:@""];
    NSMenu *textualSupportMenu = [NSMenu new];
	[textualSupportMenu setTitle:@"Textual Support"];
    NSArray *supportMessages = dict[@"userlist"];
    [TPI_TextualSupportHelper addItemsFromArrayToMenu:textualSupportMenu menuItems:supportMessages selector:@selector(postMenuMessage:)];
    [textualSupportMenuItems setSubmenu: textualSupportMenu];
	[userlistMenu addItem:[textualSupportMenuItems copy]];
    
    NSMenuItem *textualInsertLinksMenuItems = [[NSMenuItem alloc] init];
    [textualInsertLinksMenuItems setTitle:@"Insert Support Link"];
    [textualInsertLinksMenuItems setKeyEquivalent:@""];
    NSMenu *textualInsertLinksMenu = [NSMenu new];
    [textualInsertLinksMenuItems setTitle:@"Insert Support Link"];
    NSArray *insertLinkMessages = dict[@"insertlink"];
    [TPI_TextualSupportHelper addItemsFromArrayToMenu:textualInsertLinksMenu menuItems:insertLinkMessages selector:@selector(postLinkToInputField:)];
    [textualInsertLinksMenuItems setSubmenu:textualInsertLinksMenu];
    [inputFieldMenu addItem:[textualInsertLinksMenuItems copy]];
    
    NSInteger indexOfBanItem = [userlistMenu indexOfItemWithTitle:@"Ban"];
    
    NSMenuItem *textualUnbanUserMenuItem = [[NSMenuItem alloc] init];
    [textualUnbanUserMenuItem setTitle:@"Unban"];
    [textualUnbanUserMenuItem setKeyEquivalent:@""];
    [textualUnbanUserMenuItem setTarget:menuController()];
    [textualUnbanUserMenuItem setAction:@selector(unmuteUserOnChannel:)];
    [textualUnbanUserMenuItem setTag:424201];
    [userlistMenu insertItem:textualUnbanUserMenuItem atIndex:(indexOfBanItem + 1)];
    
    NSMenuItem *textualMuteUserMenuItem = [[NSMenuItem alloc] init];
    [textualMuteUserMenuItem setTitle:@"Mute"];
    [textualMuteUserMenuItem setKeyEquivalent:@""];
    [textualMuteUserMenuItem setTarget:menuController()];
    [textualMuteUserMenuItem setAction:@selector(muteUserOnChannel:)];
    [textualMuteUserMenuItem setTag:424202];
    [userlistMenu insertItem:textualMuteUserMenuItem atIndex:(indexOfBanItem + 2)];
    
    
    NSMenuItem *textualUnmuteUserMenuItem = [[NSMenuItem alloc] init];
    [textualUnmuteUserMenuItem setTitle:@"Unmute"];
    [textualUnmuteUserMenuItem setKeyEquivalent:@""];
    [textualUnmuteUserMenuItem setTarget:menuController()];
    [textualUnmuteUserMenuItem setAction:@selector(unmuteUserOnChannel:)];
    [userlistMenu insertItem:textualUnmuteUserMenuItem atIndex:(indexOfBanItem + 3)];
    
    self.menuController.userControlMenu = userlistMenu;
    
}

- (void)overrideExistingMenuItems {
    [[userlistMenu itemWithTag:504910] setAction:@selector(giveOperatorStatusToUser:)];
    [[userlistMenu itemWithTag:504912] setAction:@selector(giveVoiceStatusToUser:)];
    
    [[userlistMenu itemWithTag:504810] setAction:@selector(revokeOperatorStatusFromUser:)];
    [[userlistMenu itemWithTag:504812] setAction:@selector(revokeVoiceStatusFromUser:)];
    
    [[userlistMenu itemWithTitle:@"Ban"] setAction:@selector(banUserFromChannel:)];
    [[userlistMenu itemWithTitle:@"Kick"] setAction:@selector(kickUserFromChannel:)];
    [[userlistMenu itemWithTitle:@"Ban and Kick"] setAction:@selector(kickBanUserFromChannel:)];
}

@end
