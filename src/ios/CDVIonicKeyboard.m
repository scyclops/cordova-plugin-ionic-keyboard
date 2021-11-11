/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVIonicKeyboard.h"
#import <Cordova/CDVAvailability.h>
#import <Cordova/NSDictionary+CordovaPreferences.h>
#import <objc/runtime.h>

@implementation CDVIonicKeyboard

NSTimer *hideTimer;

#pragma mark Initialize

- (void)pluginInitialize
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(onKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [nc addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark Keyboard events

- (void)onKeyboardWillHide:(NSNotification *)sender
{
    hideTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(fireOnHiding) userInfo:nil repeats:NO];
}

- (void)fireOnHiding {
    [self.commandDelegate evalJs:@"Keyboard.fireOnHiding();"];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    if (hideTimer != nil) {
        [hideTimer invalidate];
    }

    [self.commandDelegate evalJs:@"Keyboard.fireOnShowing();"];
}

- (void)onKeyboardDidShow:(NSNotification *)note
{
    [self.commandDelegate evalJs:@"Keyboard.fireOnShow();"];
}

- (void)onKeyboardDidHide:(NSNotification *)sender
{
    [self.commandDelegate evalJs:@"Keyboard.fireOnHide();"];
}

#pragma mark dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
