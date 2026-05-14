let
  autoCalledPackages = import ./by-name-overlay.nix ../os-specific/darwin/by-name;
in

{
  lib,
  buildEnv,
  cctools,
  generateSplicesForMkScope,
  libc,
  llvmPackages,
  makeScopeWithSplicing',
  pkgs,
  preLibcHeaders,
  stdenv,
  targetPackages,
  wrapBintoolsWith,
  config,
}:

let
  aliases =
    final: prev:
    lib.optionalAttrs config.allowAliases (import ../top-level/darwin-aliases.nix lib final prev pkgs);

  autoCalledPackagesWithAliases = lib.composeManyExtensions [
    autoCalledPackages
    aliases
  ];

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
  extra = self: {
    inherit (llvmPackages) clang-unwrapped;

    # This is an internal helper for building source-release packages.
    # It’s not intended for use outside of the Darwin package set.
    mkAppleDerivation = self.callPackage ../os-specific/darwin/mk-apple-derivation { };
  };
  f = lib.extends autoCalledPackagesWithAliases (
    self:
    lib.recurseIntoAttrs {
      inherit (self.adv_cmds) ps;

      # Removes propagated packages from the stdenv, so those packages can be built without depending upon themselves.
      bootstrapStdenv = mkBootstrapStdenv stdenv;

      # Note: Not in `package.nix` because it messes up the overrides.
      binutils = wrapBintoolsWith {
        libc = targetPackages.libc or libc;
        bintools = self.binutils-unwrapped;
      };

      binutilsNoLibc = wrapBintoolsWith {
        libc = targetPackages.preLibcHeaders or preLibcHeaders;
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
      binutilsDualAs-unwrapped = buildEnv {
        name = "${lib.getName self.binutils-unwrapped}-dualas-${lib.getVersion self.binutils-unwrapped}";
        paths = [
          self.binutils-unwrapped
          (lib.getOutput "gas" cctools)
        ];
      };

      binutilsDualAs = self.binutils.override {
        bintools = self.binutilsDualAs-unwrapped;
      };

      sourceRelease = self.callPackage ../os-specific/darwin/sourceRelease { };

      inherit (self.file_cmds) xattr;

      # Note: Not in `packages.nix` because it’s a package set not a derivation.
      inherit (self.callPackage ../os-specific/darwin/xcode { })
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
        xcode_26_0_1
        xcode_26_0_1_Apple_silicon
        xcode_26_1
        xcode_26_1_Apple_silicon
        xcode_26_1_1
        xcode_26_1_1_Apple_silicon
        xcode_26_2
        xcode_26_2_Apple_silicon
        xcode_26_3
        xcode_26_3_Apple_silicon
        xcode_26_4
        xcode_26_4_Apple_silicon
        xcode_26_4_1
        xcode_26_4_1_Apple_silicon
        xcode
        requireXcode
        ;

      # Note: Not in `package.nix` because it references files outside of the package.
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
  );
}
