forceLinkCoreFoundationFramework() {
  NIX_CFLAGS_COMPILE="-F@out@/Library/Frameworks${NIX_CFLAGS_COMPILE:+ }${NIX_CFLAGS_COMPILE-}"
<<<<<<< HEAD
  NIX_LDFLAGS+=" @out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd"
=======
  NIX_LDFLAGS+=" @out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}

preConfigureHooks+=(forceLinkCoreFoundationFramework)
