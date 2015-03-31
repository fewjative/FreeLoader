# FreeLoader
Frees iOS from its loading indicator frame count limitation. Also allows for custom image sets for the indicators(without the need of Winterboard).

Everything you need to know about customs themes:

Currently, there are 4 themeable styles - White, WhiteLarge, Gray, and StatusBar which correspond to:
UIActivityIndicatorViewStyleWhite

UIActivityIndicatorViewStyleWhiteLarge

UIActivityIndicatorViewStyleGray

UIActivityIndicatorViewStyleStatusBar

Images for the White style are 40px by 40px @2x, images for the WhiteLarge style are  74px by 74px @2x, images for the Gray style are 40px by 40px @2x, and images for the StatusBar style are 20px by 40px @2x.

Let's say we wanted to make a theme for the White style, the first image would be named UIActivityIndicatorViewStyleWhite.0@2x.png , the second would be UIActivityIndicatorViewStyleWhite.1@2x.png, the third would be UIActivityIndicatorViewStyleWhite.2@2x.png, and so on. Images must follow this naming convention to be used.

Now that we have a set of images created, what do we do with them?

FreeLoader loads its images from /Library/Application Support/FreeLoader. Places the images in a folder, we will call it 'ThemeTest', as an example. Then place this folder in the FreeLoader folder. The file structure should now look like /Library/Application Support/FreeLoader/ThemeTest/(your images inside here). Alternatively, you can create a .deb to package and install the files(will be talked about below). Inside the folder your created earlier, you can have images from each of the different styles but you can not have two of the same styles inside the same folder. Once the folder of images is on your device, you will be able to select it from the preferences.

I have a set of images created and I want to create a .deb for easy distribution and installation, what do I do?

To create the .deb, this tutorial will assume you are going to either use your device or macosx. Last resort, you can contact me @fewjative and I will help package the files up for you.

To start, create a folder with the naming convention com.XXX.YYY where XXX is your name and YYY is the theme name. For example, com.joshdoctors.windows8theme. You should check in Cydia to see if anyone has used the YYY name before, you must have a unique name. Next, create a folder called 'DEBIAN' (yes, it must be in all capitals) inside the com.joshdoctors.windows8theme folder. Also, create a folder called 'Library' inside the com.joshdoctors.windows8theme folder. Inside 'Library' , create a folder called 'Application Support'. Inside the 'Application Support' folder, create a folder called 'FreeLoader'. Inside the 'FreeLoader' folder, create a folder with the title you will give to your theme,for example 'Windows8'. Next, place all of your images into that folder.

The file structure should look like this at the moment:

com.joshdoctors.windows8theme

--DEBIAN

--Library/Application Support/FreeLoader/Windows8/(your images)

If you are at this point, you are close!

Navigate to the 'DEBIAN' folder and inside, create a file (not folder) called 'control'. This control file contains the information regarding the theme such as the package name as well as your information. You can use an editor such as TextEdit or Sublime to edit the file. An example control file is show below. As you can see, each item goes on a separate line. The package name must be unique as well as the name. This theme depends on freeloader so the freeloader package is listed as a dependency.

Package: com.joshdoctors.windows8theme

Name: Windows8 Theme

Depends: com.joshdoctors.freeloader

Version: 1.0.0

Architecture: iphoneos-arm

Description: Windows 8 theme to be used with the FreeLoader tweak.

Maintainer: Josh Doctors

Author: Josh Doctors

Section: Themes (SpringBoard)

Once you have created and saved this file, you are about ready to package it up. Invisible '.DS_STORE' files may be in your folders so if you are on a mac, you should use a tool called DS_Store Cleaner to remove them before your package the .deb.

To create the .deb

Your file structure should look like this now:

com.joshdoctors.windows8theme

--DEBIAN/control

--Library/Application Support/FreeLoader/Windows8/(your images)

Open terminal and navigate to the folder that contains com.joshdoctors.windows8theme. Enter the command 'su' (along with your password). Then enter 'dpkg -b com.joshdoctors.windows8theme'. It may give you a few warnings regarding the control file but you can ignore them. You should now see a com.joshdoctors.windows8theme.deb file. Now, when you install this .deb, it will automatically place the theme images in the correct location.







