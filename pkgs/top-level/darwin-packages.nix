{
  lib,
  buildPackages,
  pkgs,
  targetPackages,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  stdenv,
  preLibcCrossHeaders,
  config,
}:

let
  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) (
    stdenv.targetPlatform.config + "-"
  );

  # Bootstrap `fetchurl` needed to build SDK packages without causing an infinite recursion.
  fetchurlBoot = import ../build-support/fetchurl/boot.nix {
    inherit (stdenv) system;
  };

  aliases =
    self: super:
    lib.optionalAttrs config.allowAliases (import ../top-level/darwin-aliases.nix lib self super pkgs);

  mkBootstrapStdenv =
    stdenv:
    stdenv.override (old: {
      extraBuildInputs = map (
        pkg:
        if lib.isDerivation pkg && lib.getName pkg == "apple-sdk" then
          pkg.override { enableBootstrap = true; }
        else
          pkg
      ) (old.extraBuildInputs or [ ]);
    });

  mkStub = pkgs.callPackage ../os-specific/darwin/apple-sdk/mk-stub.nix { };
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "darwin";
  extra = spliced: spliced.apple_sdk.frameworks;
  f = lib.extends aliases (
    self:
    let
      inherit (self) mkDerivation callPackage;

      # Open source packages that are built from source
      apple-source-packages = lib.packagesFromDirectoryRecursive {
        callPackage = self.callPackage;
        directory = ../os-specific/darwin/apple-source-releases;
      };

      # Compatibility packages that aren’t necessary anymore
      apple-source-headers = {
        libresolvHeaders = lib.getDev self.libresolv;
        libutilHeaders = lib.getDev self.libutil;
      };

      # Must use pkgs.callPackage to avoid infinite recursion.
      impure-cmds = pkgs.callPackage ../os-specific/darwin/impure-cmds { };

      # macOS 11.0 SDK
      apple_sdk_11_0 = pkgs.callPackage ../os-specific/darwin/apple-sdk-11.0 { };

      # macOS 12.3 SDK
      apple_sdk_12_3 = pkgs.callPackage ../os-specific/darwin/apple-sdk-12.3 { };

      apple_sdk = apple_sdk_11_0;

      stubs =
        {
          inherit apple_sdk apple_sdk_11_0 apple_sdk_12_3;
          libobjc = self.objc4;
        }
        // lib.genAttrs [
          "CF"
          "CarbonHeaders"
          "CommonCrypto"
          "CoreSymbolication"
          "IOKit"
          "Libc"
          "Libinfo"
          "Libm"
          "Libnotify"
          "Librpcsvc"
          "Libsystem"
          "LibsystemCross"
          "Security"
          "architecture"
          "configd"
          "configdHeaders"
          "darwin-stubs"
          "dtrace"
          "eap8021x"
          "hfs"
          "hfsHeaders"
          "launchd"
          "libclosure"
          "libdispatch"
          "libmalloc"
          "libplatform"
          "libpthread"
          "mDNSResponder"
          "objc4"
          "ppp"
          "xnu"
        ] (mkStub apple_sdk.version);
    in

    impure-cmds
    // apple-source-packages
    // apple-source-headers
    // stubs
    // {

      stdenvNoCF = stdenv.override {
        extraBuildInputs = [ ];
      };

      inherit (self.adv_cmds) ps;

      binutils-unwrapped = callPackage ../os-specific/darwin/binutils {
        inherit (pkgs) cctools;
        inherit (pkgs.llvmPackages) clang-unwrapped llvm llvm-manpages;
      };

      binutils = pkgs.wrapBintoolsWith {
        libc = if stdenv.targetPlatform != stdenv.hostPlatform then pkgs.libcCross else pkgs.stdenv.cc.libc;
        bintools = self.binutils-unwrapped;
      };

      # x86-64 Darwin gnat-bootstrap emits assembly
      # with MOVQ as the mnemonic for quadword interunit moves
      # such as `movq %rbp, %xmm0`.
      # The clang integrated assembler recognises this as valid,
      # but unfortunately the cctools.gas GNU assembler does not;
      # it instead uses MOVD as the mnemonic.
      # The assembly that a GCC build emits is determined at build time
      # and cannot be changed afterwards.
      #
      # To build GNAT on x86-64 Darwin, therefore,
      # we need both the clang _and_ the cctools.gas assemblers to be available:
      # the former to build at least the stage1 compiler,
      # and the latter at least to be detectable
      # as the target for the final compiler.
      binutilsDualAs-unwrapped = pkgs.buildEnv {
        name = "${lib.getName self.binutils-unwrapped}-dualas-${lib.getVersion self.binutils-unwrapped}";
        paths = [
          self.binutils-unwrapped
          (lib.getOutput "gas" pkgs.cctools)
        ];
      };

      binutilsDualAs = self.binutils.override {
        bintools = self.binutilsDualAs-unwrapped;
      };

      binutilsNoLibc = pkgs.wrapBintoolsWith {
        libc = preLibcCrossHeaders;
        bintools = self.binutils-unwrapped;
      };

      # Removes propagated packages from the stdenv, so those packages can be built without depending upon themselves.
      bootstrapStdenv = mkBootstrapStdenv pkgs.stdenv;

      libSystem = callPackage ../os-specific/darwin/libSystem { };

      DarwinTools = callPackage ../os-specific/darwin/DarwinTools { };

      print-reexports = callPackage ../os-specific/darwin/print-reexports { };

      rewrite-tbd = callPackage ../os-specific/darwin/rewrite-tbd { };

      checkReexportsHook = pkgs.makeSetupHook {
        name = "darwin-check-reexports-hook";
        propagatedBuildInputs = [ pkgs.darwin.print-reexports ];
      } ../os-specific/darwin/print-reexports/setup-hook.sh;

      libunwind = callPackage ../os-specific/darwin/libunwind { };

      sigtool = callPackage ../os-specific/darwin/sigtool { };

      signingUtils = callPackage ../os-specific/darwin/signing-utils { };

      postLinkSignHook = callPackage ../os-specific/darwin/signing-utils/post-link-sign-hook.nix { };

      autoSignDarwinBinariesHook = pkgs.makeSetupHook {
        name = "auto-sign-darwin-binaries-hook";
        propagatedBuildInputs = [ self.signingUtils ];
      } ../os-specific/darwin/signing-utils/auto-sign-hook.sh;

      iosSdkPkgs = callPackage ../os-specific/darwin/xcode/sdk-pkgs.nix {
        buildIosSdk = buildPackages.darwin.iosSdkPkgs.sdk;
        targetIosSdkPkgs = targetPackages.darwin.iosSdkPkgs;
        inherit (pkgs.llvmPackages) clang-unwrapped;
      };

      lsusb = callPackage ../os-specific/darwin/lsusb { };

      openwith = callPackage ../os-specific/darwin/openwith { };

      stubs = pkgs.callPackages ../os-specific/darwin/stubs { };

      trash = callPackage ../os-specific/darwin/trash { };

      inherit (self.file_cmds) xattr;

      inherit (pkgs.callPackages ../os-specific/darwin/xcode { })
        xcode_8_1
        xcode_8_2
        xcode_9_1
        xcode_9_2
        xcode_9_3
        xcode_9_4
        xcode_9_4_1
        xcode_10_1
        xcode_10_2
        xcode_10_2_1
        xcode_10_3
        xcode_11
        xcode_11_1
        xcode_11_2
        xcode_11_3_1
        xcode_11_4
        xcode_11_5
        xcode_11_6
        xcode_11_7
        xcode_12
        xcode_12_0_1
        xcode_12_1
        xcode_12_2
        xcode_12_3
        xcode_12_4
        xcode_12_5
        xcode_12_5_1
        xcode_13
        xcode_13_1
        xcode_13_2
        xcode_13_3
        xcode_13_3_1
        xcode_13_4
        xcode_13_4_1
        xcode_14
        xcode_14_1
        xcode_15
        xcode_15_0_1
        xcode_15_1
        xcode_15_2
        xcode_15_3
        xcode_15_4
        xcode_16
        xcode_16_1
        xcode_16_2
        xcode
        requireXcode
        ;

      xcodeProjectCheckHook = pkgs.makeSetupHook {
        name = "xcode-project-check-hook";
        propagatedBuildInputs = [ pkgs.pkgsBuildHost.openssl ];
      } ../os-specific/darwin/xcode-project-check-hook/setup-hook.sh;

      # Formerly the CF attribute. Use this is you need the open source release.
      swift-corelibs-foundation = callPackage ../os-specific/darwin/swift-corelibs/corefoundation.nix { };

      # As the name says, this is broken, but I don't want to lose it since it's a direction we want to go in
      # libdispatch-broken = callPackage ../os-specific/darwin/swift-corelibs/libdispatch.nix { };

      # See doc/packages/darwin-builder.section.md
      linux-builder = lib.makeOverridable (
        { modules }:
        let
          toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];

          nixos = import ../../nixos {
            configuration = {
              imports = [
                ../../nixos/modules/profiles/nix-builder-vm.nix
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
        nixos.config.system.build.macos-builder-installer
      ) { modules = [ ]; };

      linux-builder-x86_64 = self.linux-builder.override {
        modules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
      };

    }
  );
}
