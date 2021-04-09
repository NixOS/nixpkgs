# Some frameworks have recursive dependencies - e.g. CoreData depends on
# Foundation depends on ApplicationServices depends on CoreServices depends on
# CoreData.
#
# To work around that, we have two levels of dependency structure; the
# lower-level, and the upper-level.
#
# This file defines the upper-level. Note that propagated build dependencies
# won't work properly here: listing deps here will mean that you will need to
# include it for every child as well.
#
# You should _not_ add new entries to this file unless required to break a
# dependency loop.

{ frameworks, libs, libobjc, }:

with frameworks; with libs; {
  # Frameworks which are dependencies of Foundation.
  CoreBluetooth      = { inherit Foundation; };
  CoreData           = { inherit Foundation; };
  CoreWLAN           = { inherit Foundation; };
  IOBluetooth        = { inherit Foundation; };
  IOSurface          = { inherit Foundation; };
  OpenDirectory      = { inherit Foundation; };
  SecurityFoundation = { inherit Foundation; };

  # Frameworks which are dependencies of Cocoa (but need it).
  AudioToolbox       = { inherit Cocoa; };
  AudioUnit          = { inherit Cocoa; };

  # Misc others.
  Accelerate         = { inherit CoreGraphics CoreVideo; };
}
