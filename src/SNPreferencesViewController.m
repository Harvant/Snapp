/* Copyright 2015 gbrueckner.
 *
 * This file is part of Snapp.
 *
 * Snapp is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Snapp is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Snapp.  If not, see <http://www.gnu.org/licenses/>.
 */


#import "SNPreferencesViewController.h"
#import "NSAttributedString+Hyperlink.h"
#import "NSFont+Additions.h"
#import "SNAppDelegate.h"
#import "SNTextView.h"
#import "SNView.h"
@import ServiceManagement;


@implementation SNPreferencesViewController


- (void)loadView {

    self.view = [[SNView alloc] initWithFrame:NSZeroRect];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    // Create the info label.
    NSTextView *infoLabel = [[SNTextView alloc] initWithFrame:NSZeroRect];
    infoLabel.string = @"Open Snapp twice to show this window.";
    infoLabel.alignment = NSCenterTextAlignment;
    infoLabel.drawsBackground = NO;
    infoLabel.font = [NSFont labelFont];
    infoLabel.selectable = NO;
    infoLabel.textColor = [NSColor darkGrayColor];
    [infoLabel setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow
                                        forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.view addSubview:infoLabel];
    [infoLabel release];

    // Create the login checkbox.
    NSButton *loginCheckbox = [[NSButton alloc] initWithFrame:NSZeroRect];
    loginCheckbox.title = @"Open Snapp automatically when you log in";
    loginCheckbox.buttonType = NSSwitchButton;
    loginCheckbox.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"openAtLogin"] ? NSOnState : NSOffState;
    loginCheckbox.target = self;
    loginCheckbox.action = @selector(loginCheckboxClicked:);
    [self.view addSubview:loginCheckbox];
    [loginCheckbox release];

    // Create the sound checkbox.
    NSButton *playSoundCheckbox = [[NSButton alloc] initWithFrame:NSZeroRect];
    playSoundCheckbox.title = @"Play a sound when snapping windows";
    playSoundCheckbox.buttonType = NSSwitchButton;
    playSoundCheckbox.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"playSnapSound"] ? NSOnState : NSOffState;
    playSoundCheckbox.target = self;
    playSoundCheckbox.action = @selector(playSoundCheckboxClicked:);
    [self.view addSubview:playSoundCheckbox];
    [playSoundCheckbox release];

    // Create the update checkbox.
    NSButton *updateCheckbox = [[NSButton alloc] initWithFrame:NSZeroRect];
    updateCheckbox.title = @"Check for updates automatically";
    updateCheckbox.buttonType = NSSwitchButton;
    updateCheckbox.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"checkForUpdates"] ? NSOnState : NSOffState;
    updateCheckbox.target = self;
    updateCheckbox.action = @selector(updateCheckboxClicked:);
    [self.view addSubview:updateCheckbox];
    [updateCheckbox release];

    // Create the quit button.
    NSButton *quitButton = [[NSButton alloc] initWithFrame:NSZeroRect];
    quitButton.title = @"Quit Snapp";
    quitButton.bezelStyle = NSRoundedBezelStyle;
    quitButton.target = NSApp;
    quitButton.action = @selector(terminate:);
    quitButton.keyEquivalent = @"q";
    quitButton.keyEquivalentModifierMask = NSCommandKeyMask;
    [self.view addSubview:quitButton];
    [quitButton release];

    // Create the OSS label.
    NSTextView *ossLabel = [[SNTextView alloc] initWithFrame:NSZeroRect];
    NSMutableAttributedString *ossLabelString = [[NSMutableAttributedString alloc] initWithString:@"Snapp is open source software! To learn more, visit the "];
    [ossLabelString appendAttributedString:[NSAttributedString hyperlinkFromString:@"Snapp GitHub repository"
                                   withURL:[SNAppDelegate repositoryURL]]];
    NSAttributedString *dotString = [[NSAttributedString alloc] initWithString:@"."];
    [ossLabelString appendAttributedString:dotString];
    ossLabel.textStorage.attributedString = ossLabelString;
    ossLabel.alignment = NSCenterTextAlignment;
    ossLabel.drawsBackground = NO;
    ossLabel.editable = NO;
    ossLabel.font = [NSFont labelFont];
    ossLabel.textColor = [NSColor darkGrayColor];
    [ossLabel setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow
                                       forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.view addSubview:ossLabel];
    [dotString release];
    [ossLabel release];
    [ossLabelString release];

    // Layout the subviews.
    NSDictionary *views = @{@"infoLabel": infoLabel,
                        @"loginCheckbox": loginCheckbox,
                    @"playSoundCheckbox": playSoundCheckbox,
                       @"updateCheckbox": updateCheckbox,
                           @"quitButton": quitButton,
                             @"ossLabel": ossLabel};

    [views enumerateKeysAndObjectsUsingBlock:^(NSString *viewName, NSView *view, BOOL *stop) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoLabel]-18-[loginCheckbox]-[playSoundCheckbox]-[updateCheckbox]-[quitButton]-[ossLabel]-8-|"
                                                options:NSLayoutFormatAlignAllCenterX
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ossLabel]|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[loginCheckbox]->=0-|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[playSoundCheckbox]->=0-|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[updateCheckbox]->=0-|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[quitButton]->=0-|"
                                                options:0
                                                metrics:nil
                                                  views:views]];

    [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:loginCheckbox
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:playSoundCheckbox
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:0]];

    [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:playSoundCheckbox
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:updateCheckbox
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:0]];
}


- (void)loginCheckboxClicked:(NSButton *)loginCheckbox {

    if (SMLoginItemSetEnabled(CFSTR("SnappHelper"),
                               loginCheckbox.state == NSOnState ? TRUE : FALSE)) {
         [[NSUserDefaults standardUserDefaults] setBool:(loginCheckbox.state == NSOnState)
                                                 forKey:@"openAtLogin"];
    }
    else
        [loginCheckbox setNextState];
}


- (void)playSoundCheckboxClicked:(NSButton *)playSoundCheckbox {
     [[NSUserDefaults standardUserDefaults] setBool:(playSoundCheckbox.state == NSOnState)
                                             forKey:@"playSnapSound"];
}


- (void)updateCheckboxClicked:(NSButton *)updateCheckbox {
     [[NSUserDefaults standardUserDefaults] setBool:(updateCheckbox.state == NSOnState)
                                             forKey:@"checkForUpdates"];
}


@end
