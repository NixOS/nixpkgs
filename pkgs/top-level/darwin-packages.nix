{ lib
, buildPackages, pkgs, targetPackages
, generateSplicesForMkScope, makeScopeWithSplicing'
, stdenv
, preLibcCrossHeaders
, config
}:

let
  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                                        (stdenv.targetPlatform.config + "-");

  # Bootstrap `fetchurl` needed to build SDK packages without causing an infinite recursion.
  fetchurlBoot = import ../build-support/fetchurl/boot.nix {
    inherit (stdenv) system;
  };
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "darwin";
  extra = spliced: spliced.apple_sdk.frameworks;
  f = (self: let
  inherit (self) mkDerivation callPackage;

  # Must use pkgs.callPackage to avoid infinite recursion.

  # Open source packages that are built from source
  appleSourcePackages = pkgs.callPackage ../os-specific/darwin/apple-source-releases { } self;

  impure-cmds = pkgs.callPackage ../os-specific/darwin/impure-cmds { };

  # macOS 10.12 SDK
  apple_sdk_10_12 = pkgs.callPackage ../os-specific/darwin/apple-sdk {
    inherit (buildPackages.darwin) print-reexports;
    inherit (self) darwin-stubs;
    fetchurl = fetchurlBoot;
  };

  # macOS 11.0 SDK
  apple_sdk_11_0 = pkgs.callPackage ../os-specific/darwin/apple-sdk-11.0 {
    fetchurl = fetchurlBoot;
  };

  # Pick an SDK
  apple_sdk = if stdenv.hostPlatform.isAarch64 then apple_sdk_11_0 else apple_sdk_10_12;

  # Pick the source of libraries: either Apple's open source releases, or the
  # SDK.
  useAppleSDKLibs = stdenv.hostPlatform.isAarch64;

  selectAttrs = attrs: names:
    lib.listToAttrs (lib.concatMap (n: lib.optionals (attrs ? "${n}") [(lib.nameValuePair n attrs."${n}")]) names);

  chooseLibs = (
    # There are differences in which libraries are exported. Avoid evaluation
    # errors when a package is not provided.
    selectAttrs (
      if useAppleSDKLibs
        then apple_sdk
        else appleSourcePackages
    ) ["Libsystem" "LibsystemCross" "libcharset" "libunwind" "objc4" "configd" "IOKit"]
  ) // {
    inherit (
      if useAppleSDKLibs
        then apple_sdk.frameworks
        else appleSourcePackages
    ) Security;
  };
in

impure-cmds // appleSourcePackages // chooseLibs // {

  inherit apple_sdk apple_sdk_10_12 apple_sdk_11_0;

  stdenvNoCF = stdenv.override {
    extraBuildInputs = [];
  };

  binutils-unwrapped = callPackage ../os-specific/darwin/binutils {
    inherit (pkgs) binutils-unwrapped;
    inherit (pkgs.llvmPackages) llvm clang-unwrapped;
  };

  binutils = pkgs.wrapBintoolsWith {
    libc =
      if stdenv.targetPlatform != stdenv.hostPlatform
      then pkgs.libcCross
      else pkgs.stdenv.cc.libc;
    bintools = self.binutils-unwrapped;
  };

  binutilsDualAs-unwrapped = callPackage ../os-specific/darwin/binutils {
    inherit (pkgs) binutils-unwrapped;
    inherit (pkgs.llvmPackages) llvm clang-unwrapped;
    dualAs = true;
  };

  binutilsDualAs = pkgs.wrapBintoolsWith {
    libc =
      if stdenv.targetPlatform != stdenv.hostPlatform
      then pkgs.libcCross
      else pkgs.stdenv.cc.libc;
    bintools = self.binutilsDualAs-unwrapped;
  };

  binutilsNoLibc = pkgs.wrapBintoolsWith {
    libc = preLibcCrossHeaders;
    bintools = self.binutils-unwrapped;
  };

  cctools = self.cctools-llvm;

  cctools-apple = callPackage ../os-specific/darwin/cctools/apple.nix {
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
  };

  cctools-llvm = callPackage ../os-specific/darwin/cctools/llvm.nix {
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
  };

  cctools-port = callPackage ../os-specific/darwin/cctools/port.nix {
    stdenv = if stdenv.isDarwin then stdenv else pkgs.libcxxStdenv;
  };

  # TODO(@connorbaker): See https://github.com/NixOS/nixpkgs/issues/229389.
  cf-private = self.apple_sdk.frameworks.CoreFoundation;

  DarwinTools = callPackage ../os-specific/darwin/DarwinTools { };

  darwin-stubs = callPackage ../os-specific/darwin/darwin-stubs { };

  print-reexports = callPackage ../os-specific/darwin/print-reexports { };

  rewrite-tbd = callPackage ../os-specific/darwin/rewrite-tbd { };

  checkReexportsHook = pkgs.makeSetupHook {
    name = "darwin-check-reexports-hook";
    propagatedBuildInputs = [ pkgs.darwin.print-reexports ];
  } ../os-specific/darwin/print-reexports/setup-hook.sh;

  sigtool = callPackage ../os-specific/darwin/sigtool { };

  signingUtils = callPackage ../os-specific/darwin/signing-utils { };

  postLinkSignHook = callPackage ../os-specific/darwin/signing-utils/post-link-sign-hook.nix { };

  autoSignDarwinBinariesHook = pkgs.makeSetupHook {
    name = "auto-sign-darwin-binaries-hook";
    propagatedBuildInputs = [ self.signingUtils ];
  } ../os-specific/darwin/signing-utils/auto-sign-hook.sh;

  maloader = callPackage ../os-specific/darwin/maloader {
  };

  insert_dylib = callPackage ../os-specific/darwin/insert_dylib { };

  iosSdkPkgs = callPackage ../os-specific/darwin/xcode/sdk-pkgs.nix {
    buildIosSdk = buildPackages.darwin.iosSdkPkgs.sdk;
    targetIosSdkPkgs = targetPackages.darwin.iosSdkPkgs;
    inherit (pkgs.llvmPackages) clang-unwrapped;
  };

  iproute2mac = callPackage ../os-specific/darwin/iproute2mac { };

  libobjc = self.objc4;

  lsusb = callPackage ../os-specific/darwin/lsusb { };

  moltenvk = pkgs.darwin.apple_sdk_11_0.callPackage ../os-specific/darwin/moltenvk {
    inherit (apple_sdk_11_0.frameworks) AppKit Foundation Metal QuartzCore;
    inherit (apple_sdk_11_0) MacOSX-SDK Libsystem;
    inherit (pkgs.darwin) cctools sigtool;
  };

  opencflite = callPackage ../os-specific/darwin/opencflite { };

  openwith = pkgs.darwin.apple_sdk_11_0.callPackage ../os-specific/darwin/openwith {
    inherit (apple_sdk_11_0.frameworks) AppKit Foundation UniformTypeIdentifiers;
  };

  stubs = pkgs.callPackages ../os-specific/darwin/stubs { };

  trash = callPackage ../os-specific/darwin/trash { };

  xattr = pkgs.python3Packages.callPackage ../os-specific/darwin/xattr { };

  inherit (pkgs.callPackages ../os-specific/darwin/xcode { })
    xcode_8_1 xcode_8_2
    xcode_9_1 xcode_9_2 xcode_9_3 xcode_9_4 xcode_9_4_1
    xcode_10_1 xcode_10_2 xcode_10_2_1 xcode_10_3
    xcode_11 xcode_11_1 xcode_11_2 xcode_11_3_1 xcode_11_4 xcode_11_5 xcode_11_6 xcode_11_7
    xcode_12 xcode_12_0_1 xcode_12_1 xcode_12_2 xcode_12_3 xcode_12_4 xcode_12_5 xcode_12_5_1
    xcode_13 xcode_13_1 xcode_13_2 xcode_13_3 xcode_13_3_1 xcode_13_4 xcode_13_4_1
    xcode_14 xcode_14_1
    xcode_15 xcode_15_1
    xcode;

  CoreSymbolication = callPackage ../os-specific/darwin/CoreSymbolication { };

  # TODO: Remove the CF hook if a solution to the crashes is not found.
  CF =
    # CF used to refer to the open source version of CoreFoundation from the Swift
    # project. As of macOS 14, the rpath-based approach allowing packages to choose
    # which version to use no longer seems to work reliably. Sometimes they works,
    # but sometimes they crash with the error (in the system crash logs):
    # CF objects must have a non-zero isa.
    # See https://developer.apple.com/forums/thread/739355 for more on that error.
    #
    # In this branch, we only have a single "CoreFoundation" to choose from.
    # To be compatible with the existing convention, we define
    # CoreFoundation with the setup hook, and CF as the same package but
    # with the setup hook removed.
    #
    # This may seem unimportant, but without it packages (e.g., bacula) will
    # fail with linker errors referring ___CFConstantStringClassReference.
    # It's not clear to me why some packages need this extra setup.
    lib.overrideDerivation apple_sdk.frameworks.CoreFoundation (drv: {
      setupHook = null;
    });

  # Formerly the CF attribute. Use this is you need the open source release.
  swift-corelibs-foundation = callPackage ../os-specific/darwin/swift-corelibs/corefoundation.nix { };

  # As the name says, this is broken, but I don't want to lose it since it's a direction we want to go in
  # libdispatch-broken = callPackage ../os-specific/darwin/swift-corelibs/libdispatch.nix { };

  libtapi = callPackage ../os-specific/darwin/libtapi {};

  ios-deploy = callPackage ../os-specific/darwin/ios-deploy {};

  discrete-scroll = callPackage ../os-specific/darwin/discrete-scroll { };

  # See doc/builders/special/darwin-builder.section.md
  linux-builder = lib.makeOverridable ({ modules }:
    let
      toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];

      nixos = import ../../nixos {
        configuration = {
          imports = [
            ../../nixos/modules/profiles/macos-builder.nix
          ] ++ modules;

          # If you need to override this, consider starting with the right Nixpkgs
          # in the first place, ie change `pkgs` in `pkgs.darwin.linux-builder`.
          # or if you're creating new wiring that's not `pkgs`-centric, perhaps use the
          # macos-builder profile directly.
          virtualisation.host = { inherit pkgs; };

          nixpkgs.hostPlatform = lib.mkDefault (toGuest stdenv.hostPlatform.system);
        };

        system = null;
      };

    in
      nixos.config.system.build.macos-builder-installer) { modules = [ ]; };

  linux-builder-x86_64 = self.linux-builder.override {
    modules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
  };

} // lib.optionalAttrs config.allowAliases {
  builder = throw "'darwin.builder' has been changed and renamed to 'darwin.linux-builder'. The default ssh port is now 31022. Please update your configuration or override the port back to 22. See https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder"; # added 2023-07-06
});
}
