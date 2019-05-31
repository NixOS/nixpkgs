{ CF, apple_sdk }:

# cf-private is a bit weird, but boils down to CF with a weird setup-hook that
# makes a build link against the system CoreFoundation rather than our pure one.
# The reason it exists is that although our CF headers and build are pretty legit
# now, the underlying runtime is quite different. Apple's in a bit of flux around CF
# right now, and support three different backends for it: swift, "C", and an ObjC
# one. The former two can be built from public sources, but the ObjC one isn't really
# public. Unfortunately, it's also one of the core underpinnings of a lot of Mac-
# specific behavior, and defines a lot of symbols that some Objective C apps depend
# on, even though one might expect those symbols to derive from Foundation. So if
# your app relies on NSArray and several other basic ObjC types, it turns out that
# because of their magic "toll-free bridging" support, the symbols for those types
# live in CoreFoundation with an ObjC runtime. And because that isn't public, we have
# this hack in place to let people link properly anyway. Phew!
#
# This can be revisited if Apple ever decide to release the ObjC backend in a publicly
# buildable form.
#
# This doesn't really need to rebuild CF, but it's cheap, and adding a setup hook to
# an existing package was annoying. We need a buildEnv that knows how to add those
CF.overrideAttrs (orig: {
  # PLEASE if you add things to this derivation, explain in reasonable detail why
  # you're adding them and when the workaround can go away. This whole derivation is
  # a workaround and if you don't explain what you're working around, it makes it
  # very hard for people to clean it up later.

  name = "${orig.name}-private";
  setupHook = ./setup-hook.sh;

  # TODO: consider re-adding https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-source-releases/CF/cf-bridging.patch
  # once the missing headers are in and see if that fixes all need for this.

  # This can go away once https://bugs.swift.org/browse/SR-8741 happens, which is
  # looking more likely these days with the friendly people at Apple! We only need
  # the header because the setup hook takes care of linking us against a version
  # of the framework with the functionality built into it. The main user I know of
  # this is watchman, who can almost certainly switch to the pure CF once the header
  # and functionality is merged in.
  installPhase = orig.installPhase + ''
    basepath="Library/Frameworks/CoreFoundation.framework/Headers"

    # Append the include at top level or nobody will notice the header we're about to add
    sed -i '/CFNotificationCenter.h/a #include <CoreFoundation/CFFileDescriptor.h>' \
      "$out/$basepath/CoreFoundation.h"

    cp ${apple_sdk.frameworks.CoreFoundation}/$basepath/CFFileDescriptor.h $out/$basepath/CFFileDescriptor.h
  '' +
  # This one is less likely to go away, but I'll mention it anyway. The issue is at
  # https://bugs.swift.org/browse/SR-8744, and the main user I know of is qtbase
  ''
    path="$basepath/CFURLEnumerator.h"
    sed -i '/CFNotificationCenter.h/a #include <CoreFoundation/CFURLEnumerator.h>' \
      "$out/$basepath/CoreFoundation.h"

    cp ${apple_sdk.frameworks.CoreFoundation}/$path $out/$path
  '';
})
