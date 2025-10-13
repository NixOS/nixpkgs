{
  lib,
  buildPackages,
  pkgs,
  targetPackages,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  stdenv,
  config,
}:

let
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
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "darwin";
  f = lib.extends aliases (
    self:
    let
      inherit (self) mkDerivation callPackage;

      # Open source packages that are built from source
      apple-source-packages = lib.packagesFromDirectoryRecursive {
        callPackage = self.callPackage;
        directory = ../os-specific/darwin/apple-source-releases;
      };

      # Must use pkgs.callPackage to avoid infinite recursion.
      impure-cmds = pkgs.callPackage ../os-specific/darwin/impure-cmds { };
    in

    lib.recurseIntoAttrs (
      impure-cmds
      // apple-source-packages
      // {

        inherit (self.adv_cmds) ps;

        binutils-unwrapped = callPackage ../os-specific/darwin/binutils {
          inherit (pkgs) cctools;
          inherit (pkgs.llvmPackages) clang-unwrapped llvm llvm-manpages;
        };

        binutils = pkgs.wrapBintoolsWith {
          inherit (targetPackages) libc;
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
          libc = targetPackages.preLibcHeaders;
          bintools = self.binutils-unwrapped;
        };

        # Removes propagated packages from the stdenv, so those packages can be built without depending upon themselves.
        bootstrapStdenv = mkBootstrapStdenv pkgs.stdenv;

        libSystem = callPackage ../os-specific/darwin/libSystem { };

        DarwinTools = callPackage ../os-specific/darwin/DarwinTools { };

        libunwind = callPackage ../os-specific/darwin/libunwind { };

        sigtool = callPackage ../os-specific/darwin/sigtool { };

        signingUtils = callPackage ../os-specific/darwin/signing-utils { };

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
          xcode_16_3
          xcode_16_4
          xcode_26
          xcode_26_Apple_silicon
          xcode
          requireXcode
          ;

        xcodeProjectCheckHook = pkgs.makeSetupHook {
          name = "xcode-project-check-hook";
          propagatedBuildInputs = [ pkgs.pkgsBuildHost.openssl ];
        } ../os-specific/darwin/xcode-project-check-hook/setup-hook.sh;

        # See doc/packages/darwin-builder.section.md
        linux-builder = lib.makeOverridable (
          { modules }:
          let
            toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];

            nixos = import ../../nixos {
              configuration = {
                imports = [
                  ../../nixos/modules/profiles/nix-builder-vm.nix
                ]
                ++ modules;

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
    )
  );
}
