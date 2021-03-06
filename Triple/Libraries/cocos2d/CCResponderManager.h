/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2014 Cocos2D Authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * File autogenerated with Xcode. Adapted for cocos2d needs.
 */

// TODO: Add circular touch detection
// TODO: Grab mouse and touch by implementing onPressed, onReleased, onClicked

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

#define RESPONDER UIResponder

#pragma mark - iOS Running Responder

/**
 *  Defines a running iOS responder.
 */
@interface CCRunningResponder : NSObject

/**
 *  Holdes the target of the touch. This is the node which accepted the touch.
 */
@property (nonatomic, strong) id target;

/**
 *  Holds the current touch. Note that touches must not be retained.
 */
@property (nonatomic, weak) UITouch *touch;

/**
 *  Holdes the current event. Note that events must not be retained.
 */
@property (nonatomic, weak) UIEvent *event;

@end

#else

#pragma mark - OSX Running Responder

#import <AppKit/AppKit.h>

#define RESPONDER NSResponder

/**
 *  Defines the various mouse buttons.
 */
typedef NS_ENUM(NSInteger, CCMouseButton)
{
    /** Defines left mouse button, in mouse events on OSX. */
    CCMouseButtonLeft,
    
    /** Defines right mouse button, in mouse events on OSX. */
    CCMouseButtonRight,
    
    /** Defines other (middle) mouse button, in mouse events on OSX. */
    CCMouseButtonOther,
};

#pragma mark - CCRunningResponder

/**
 *  Defines a running OS X responder.
 */
@interface CCRunningResponder : NSObject

/**
 *  Holdes the target of the touch. This is the node which accepted the touch.
 */
@property (nonatomic, strong) id target;

/**
 *  Button in the currently ongoing event.
 */
@property (nonatomic, assign) CCMouseButton button;

@end

#endif

#pragma mark - CCResponderManager

@class CCNode;

/**
 *  Defines the size of the responder buffer.
 *  This is the maximum number of individual responders which can be active at the same time.
 */
enum
{
    CCResponderManagerBufferSize        = 1024,
};

/**
 *  The responder manager handles touches.
 */
@interface CCResponderManager : RESPONDER

/**
 *  Enables the responder manager.
 *  When the responder manager is disabled, all current touches will be cancelled and no further touch handling registered.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;     


/// -----------------------------------------------------------------------
/// @name Creating a CCResponderManager Object
/// -----------------------------------------------------------------------

/**
 *  CCResponderManager factory method.
 *
 *  @return The CCResponderManager Object.
 */
+ (CCResponderManager*)responderManager;


/// -----------------------------------------------------------------------
/// @name Initializing a CCResponderManager Object
/// -----------------------------------------------------------------------

/**
 *  Initializes a freshly created CCResponderManager object.
 *
 *  @return An initialized CCResponderManager Object.
 */
- (id)init;


/// -----------------------------------------------------------------------
/// @name CCResponderManager Management Methods
/// -----------------------------------------------------------------------

/**
 *  Discards current event.
 *  Do not call directly, call [super touchesXXX] or [super mouseXXX] in stead.
 */
- (void)discardCurrentEvent;

/**
 *  Adds a responder to the responder manager.
 *  Normally there is no need to call this method directly.
 *
 *  @param responder A CCNode object.
 */
- (void)addResponder:(CCNode *)responder;

/**
 *  Removes all responders.
 *  Normally there is no need to call this method directly.
 */
- (void)removeAllResponders;

/**
 *  Mark the responder chain as dirty, if responders state changes.
 *  Normally there is no need to call this method directly.
 */
- (void)markAsDirty;


/// -----------------------------------------------------------------------
/// @name CCResponderManager Helper Methods
/// -----------------------------------------------------------------------

/**
 *  Returns the first responder at a certain world position.
 *
 *  @param pos World position ( this in most cases maps to the screen coordinates in points ).
 *
 *  @return The CCNode at the position (if any).
 */
- (CCNode *)nodeAtPoint:(CGPoint)pos;

/**
 *  Returns a list of all responders at a certain world position.
 *
 *  @param pos World position ( this in most cases maps to the screen coordinates in points ).
 *
 *  @return Returns an array of CCNodes at the given point. The top most responder will be the first entry.
 */
- (NSArray *)nodesAtPoint:(CGPoint)pos;

@end

















































