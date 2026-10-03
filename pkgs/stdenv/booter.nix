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

  # This is a hack for resolving cross-compiled compilers' run-time
  # deps. (That is, compilers that are themselves cross-compiled, as
  # opposed to used to cross-compile packages.)
  postStage = buildPackages: {
    __raw = true;
    stdenv.cc =
      if buildPackages.stdenv.hasCC then
        if
          buildPackages.stdenv.cc.isClang or false
        # buildPackages.clang checks targetPackages.stdenv.cc (i. e. this
        # attribute) to get a sense of the its set's default compiler and
        # chooses between libc++ and libstdc++ based on that. If we hit this
        # code here, we'll cause an infinite recursion. Select an explicit
        # HOST compiler with the platform's runtime policy, preserving the
        # chosen compiler's TARGET C++ runtime provider.
        then
          (
            if buildPackages.stdenv.targetPlatform.useLLVM or false then
              buildPackages.llvmPackages.clangUseLLVM
            else
              buildPackages.llvmPackages.libcxxClang
          ).override
            {
              inherit (buildPackages.stdenv.cc) libcxx gccForLibs useCcForLibs;
            }
        else
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
