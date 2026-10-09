# This file defines a single function for booting a package set from a list of
# stages. The exact mechanics of that function are defined below; here I
# (@Ericson2314) wish to describe the purpose of the abstraction.
#
# The first goal is consistency across stdenvs. Regardless of what this function
# does, by making every stdenv use it for bootstrapping we ensure that they all
# work in a similar way. [Before this abstraction, each stdenv was its own
# special snowflake due to different authors writing in different times.]
#
# The second goal is consistency across each stdenv's stage functions. By
# writing each stage in terms of the previous stage, commonalities between them
# are more easily observable. [Before, there usually was a big attribute set
# with each stage, and stages would access the previous stage by name.]
#
# The third goal is composition. Because each stage is written in terms of the
# previous, the list can be reordered or, more practically, extended with new
# stages. The latter is used for cross compiling and custom
# stdenvs. Additionally, certain options should by default apply only to the
# last stage, whatever it may be. By delaying the creation of stage package sets
# until the stage graph is constructed, we prevent these options from inhibiting composition.
#
# The fourth and final goal is debugging. Normal packages should only source
# their dependencies from the current stage. But for the sake of debugging, it
# is nice that all packages still remain accessible. We make sure previous
# stages are kept around with a `stdenv.__bootPackages` attribute referring the
# previous stage. It is idiomatic that attributes prefixed with `__` come with
# special restrictions and should not be used under normal circumstances.
{ lib, allPackages }:

# Type:
#   [ pkgset -> (args to stage/default.nix) or ({ __raw = true; } // pkgs) ]
#   -> [ pkgset ]
#
# In English: This takes a list of function from the previous stage pkgset and
# returns the stage package sets, final stage first. Each stage returns, if `__raw` is
# undefined or false, args for this stage's pkgset (the most complex and
# important arg is the stdenv), or, if `__raw = true`, simply this stage's
# pkgset itself.
#
# The input lists stages in bootstrap order; the final stage comes last.
stageFuns:
let

  # Construct one stage with its neighboring package sets. Positions count
  # backward from the final stage, which defaults to allowing custom overrides.
  bootStage =
    index: stageFun:
    let
      nextStage = if index == 1 then postStage pkgs else builtins.elemAt bootedStages (index - 2);
      prevStage = if index == builtins.length stageFuns then { } else builtins.elemAt bootedStages index;
      args = {
        allowCustomOverrides = index == 1;
      }
      // (stageFun prevStage);
      args' = args // {
        stdenv = args.stdenv // {
          # For debugging
          __bootPackages = prevStage;
          __hatPackages = nextStage;
        };
      };
      thisStage =
        if args.__raw or false then
          args'
        else
          allPackages index (
            (removeAttrs args' [ "selfBuild" ])
            // {
              adjacentPackages =
                if args.selfBuild or true then
                  null
                else
                  rec {
                    pkgsBuildBuild = prevStage.buildPackages;
                    pkgsBuildHost = prevStage;
                    pkgsBuildTarget =
                      if lib.systems.equals args.stdenv.targetPlatform args.stdenv.hostPlatform then
                        pkgsBuildHost
                      else
                        assert lib.systems.equals args.stdenv.hostPlatform args.stdenv.buildPlatform;
                        thisStage;
                    pkgsHostHost =
                      if lib.systems.equals args.stdenv.hostPlatform args.stdenv.targetPlatform then
                        thisStage
                      else
                        assert lib.systems.equals args.stdenv.buildPlatform args.stdenv.hostPlatform;
                        pkgsBuildHost;
                    pkgsTargetTarget = nextStage;
                  };
            }
          );
    in
    thisStage;

  # Compiler recipes use this final companion for TARGET runtime and linker
  # dependencies. For GNU/Clang it also provides the selected HOST frontend;
  # other toolchains retain the existing GNU resource-provider fallback.
  postStage = buildPackages: {
    __raw = true;
    stdenv.cc =
      if buildPackages.stdenv.hasCC then
        let
          cc = buildPackages.stdenv.cc;
          isClang = cc.isClang or false;
          isGNU = cc.isGNU or false;
          # The selected constructor was called in (B,B,H). Retain its
          # selections while supplying the corresponding (B,H,H) role table.
          # Only derivations carry this internal table; ordinary option sets
          # (and explicit unspliced dependency pins) are not reinterpreted.
          project =
            value:
            if lib.isDerivation value && value ? __spliced then
              let
                s = value.__spliced;
              in
              (buildPackages.splicePackages {
                pkgsBuildBuild.value = s.buildBuild;
                pkgsBuildHost.value = s.buildTarget;
                pkgsBuildTarget.value = s.buildTarget;
                pkgsHostHost.value = s.targetTarget;
                pkgsHostTarget.value = s.targetTarget;
                pkgsTargetTarget.value = s.targetTarget;
              }).value
            else
              value;
          # Package graph references denote contexts, while unspliced explicit
          # inputs remain caller selections. Re-call each original constructor.
          adaptStdenv = import ./cross/adapt-stdenv.nix {
            inherit lib;
            buildPackages = buildPackages.buildPackages;
            inherit (buildPackages.stdenv) hostPlatform targetPlatform;
          };
          projectStdenv =
            value:
            adaptStdenv (
              if value.hasCC then
                let
                  original = value.cc;
                  selected =
                    if
                      original ? stdenv
                      && lib.systems.equals original.stdenv.hostPlatform buildPackages.stdenv.buildPlatform
                      && lib.systems.equals original.stdenv.targetPlatform buildPackages.stdenv.hostPlatform
                    then
                      original
                    else
                      cc;
                in
                buildPackages.overrideCC value selected
              else
                value
            );
          context = {
            inherit (buildPackages)
              buildPackages
              pkgsBuildTarget
              targetPackages
              callPackage
              ;
            _systemInfo = {
              buildIsHost = lib.systems.equals buildPackages.stdenv.buildPlatform buildPackages.stdenv.hostPlatform;
              hostIsTarget = lib.systems.equals buildPackages.stdenv.hostPlatform buildPackages.stdenv.targetPlatform;
            };
          };
          recall =
            package: f:
            let
              args = lib.functionArgs package.override;
            in
            package.override (
              original:
              # Defaults absent from captured constructor values cannot be
              # transported without replaying their defining closure.
              assert lib.assertMsg (lib.all
                (name: !(builtins.hasAttr name args) || builtins.hasAttr name original)
                [
                  "stdenv"
                  "stdenvNoCC"
                ]
              ) "stdenv compiler projection requires explicitly captured stdenv/stdenvNoCC constructor arguments";
              lib.mapAttrs (
                name: value: if name == "stdenv" || name == "stdenvNoCC" then projectStdenv value else project value
              ) original
              // lib.intersectAttrs args context
              // f original
            );
          wrapperShell =
            original:
            lib.optionalAttrs
              (
                original ? runtimeShell
                && original ? stdenvNoCC
                && original.runtimeShell == original.stdenvNoCC.shell
              )
              {
                inherit (buildPackages) runtimeShell;
              };
          raw = recall cc.cc (_: { });
          linkerRaw = recall cc.bintools.bintools (_: { });
          linker = recall cc.bintools (
            original:
            wrapperShell original
            // {
              bintools = linkerRaw;
              inherit (cc) libc;
            }
          );
          useGccForLibs =
            cc.useGccForLibs or (import ../build-support/cc-wrapper/use-gcc-for-libs.nix (
              cc
              // {
                targetPlatform = cc.stdenv.targetPlatform;
              }
            ));
        in
        if lib.systems.equals cc.stdenv.hostPlatform buildPackages.stdenv.hostPlatform then
          cc
        else if isGNU || isClang then
          assert lib.assertMsg (
            lib.systems.equals cc.stdenv.buildPlatform buildPackages.stdenv.buildPlatform
            && lib.systems.equals cc.stdenv.hostPlatform buildPackages.stdenv.buildPlatform
            && lib.systems.equals cc.stdenv.targetPlatform buildPackages.stdenv.hostPlatform
            && lib.systems.equals buildPackages.stdenv.hostPlatform buildPackages.stdenv.targetPlatform
          ) "stdenv compiler projection requires (BUILD,BUILD,HOST) -> (BUILD,HOST,HOST) contexts";
          recall cc (
            original:
            wrapperShell original
            // {
              cc = raw;
              bintools = linker;
              inherit (cc)
                libc
                libcxx
                gccForLibs
                useCcForLibs
                ;
            }
            // lib.optionalAttrs (isGNU && cc.libcxx == null && !useGccForLibs) {
              gccForLibs = cc.cc;
              useCcForLibs = true;
            }
          )
        else
          # This supplies runtime resources, not the selected toolchain's HOST
          # executable. Its constructors need not support the projection above.
          buildPackages.gcc
      else
        # This will blow up if anything uses it, but that's OK. The `if
        # buildPackages.stdenv.cc.isClang then ... else ...` would blow up
        # everything, so we make sure to avoid that.
        buildPackages.stdenv.cc;
  };

  # The list is ordered from the final stage back through bootstrap stages.
  # Bind it recursively so both adjacent stages share these same lazy values.
  bootedStages = lib.lists.imap1 bootStage (lib.lists.reverseList stageFuns);
  pkgs = builtins.head bootedStages;

in
bootedStages
