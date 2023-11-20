linkSystemCoreFoundationFramework() {
  NIX_CFLAGS_COMPILE="-F@out@/Library/Frameworks${NIX_CFLAGS_COMPILE:+ }${NIX_CFLAGS_COMPILE-}"
  # gross! many symbols (such as _OBJC_CLASS_$_NSArray) are defined in system CF, but not
  # in the opensource release
  # if the package needs private headers, we assume they also want to link with system CF
  NIX_LDFLAGS+=" @out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd"
}

preConfigureHooks+=(linkSystemCoreFoundationFramework)
