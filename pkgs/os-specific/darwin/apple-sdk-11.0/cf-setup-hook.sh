forceLinkCoreFoundationFramework() {
  NIX_CFLAGS_COMPILE="-F@out@/Library/Frameworks${NIX_CFLAGS_COMPILE:+ }${NIX_CFLAGS_COMPILE-}"
  NIX_LDFLAGS+=" @out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd"
}

preConfigureHooks+=(forceLinkCoreFoundationFramework)
