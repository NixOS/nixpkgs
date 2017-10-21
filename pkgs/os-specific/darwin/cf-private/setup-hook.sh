prependSearchPath() {
  NIX_CFLAGS_COMPILE="-F@out@/Library/Frameworks ${NIX_CFLAGS_COMPILE}"
}

linkWithRealCF() {
  # gross! many symbols (such as _OBJC_CLASS_$_NSArray) are defined in system CF, but not
  # in the opensource release
  # if the package needs private headers, we assume they also want to link with system CF
  NIX_LDFLAGS+=" /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation"
}

preConfigureHooks+=(prependSearchPath linkWithRealCF)
