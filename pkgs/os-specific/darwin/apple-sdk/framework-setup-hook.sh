# This configures the stdenv to use /System/Library/Frameworks/CoreFoundation.framework
# instead of the nix version by including the system frameworks path
# as an rpath entry when creating binaries.

useSystemCoreFoundationFramework () {
  export NIX_COREFOUNDATION_RPATH=/System/Library/Frameworks
}

envHooks+=(useSystemCoreFoundationFramework)
