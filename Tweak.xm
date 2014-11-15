/**
 * Name: DedupeVariants
 * Type: iOS SpringBoard extension (MobileSubstrate-based)
 * Desc: Remove duplicate entries from key popups.
 *       Supports iOS 5.0 ~ 7.1.1 (and possibly future versions).
 *
 * Author: Lance Fetters (aka. ashikase)
 * License: New BSD (See LICENSE file for details)
 */

#include <objc/runtime.h>

// Class declarations

@interface UIKBTree : NSObject <NSCopying>
@property(copy, nonatomic) NSString *name;
- (NSString *)representedString;
@end

//==============================================================================

// DESC: Remove entry for pressed key from list of variants.

static BOOL shouldFilter$ = NO;

%hook UIKeyboardLayoutStar

- (void)showPopupVariantsForKey:(id)key {
    shouldFilter$ = !([[key name] isEqualToString:@"Thai-Accents"] && [[key representedString] isEqualToString:@"\u0e48"]);
    %orig();
    shouldFilter$ = NO;
}

%end

%hook UIKBTree

- (void)setSubtrees:(NSMutableArray *)subtrees {
    if (shouldFilter$) {
        NSString *name = [NSString stringWithFormat:@"%@/%@", [self name], [self representedString]];
        NSUInteger count = [subtrees count];
        for (NSUInteger i = 0; i < count; ++i) {
            UIKBTree *subtree = [subtrees objectAtIndex:i];
            if ([[subtree name] isEqualToString:name]) {
                [subtrees removeObjectAtIndex:i];
                break;
            }
        }
    }

    %orig();
}

%end

/* vim: set filetype=objcpp sw=4 ts=4 sts=4 expandtab textwidth=80 ff=unix: */
