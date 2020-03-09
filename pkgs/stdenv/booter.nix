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
# writing each stage it terms of the previous stage, commonalities between them
# are more easily observable. [Before, there usually was a big attribute set
# with each stage, and stages would access the previous stage by name.]
#
# The third goal is composition. Because each stage is written in terms of the
# previous, the list can be reordered or, more practically, extended with new
# stages. The latter is used for cross compiling and custom
# stdenvs. Additionally, certain options should by default apply only to the
# last stage, whatever it may be. By delaying the creation of stage package sets
# until the final fold, we prevent these options from inhibiting composition.
#
# The fourth and final goal is debugging. Normal packages should only source
# their dependencies from the current stage. But for the sake of debugging, it
# is nice that all packages still remain accessible. We make sure previous
# stages are kept around with a `stdenv.__bootPackges` attribute referring the
# previous stage. It is idiomatic that attributes prefixed with `__` come with
# special restrictions and should not be used under normal circumstances.
{ lib, allPackages }:

# Type:
#   [ pkgset -> (args to stage/default.nix) or ({ __raw = true; } // pkgs) ]
#   -> pkgset
#
# In english: This takes a list of function from the previous stage pkgset and
# returns the final pkgset. Each of those functions returns, if `__raw` is
# undefined or false, args for this stage's pkgset (the most complex and
# important arg is the stdenv), or, if `__raw = true`, simply this stage's
# pkgset itself.
#
# The list takes stages in order, so the final stage is last in the list. In
# other words, this does a foldr not foldl.
stageFuns: let

  /* "dfold" a ternary function `op' between successive elements of `list' as if
     it was a doubly-linked list with `lnul' and `rnul` base cases at either
     end. In precise terms, `dfold op lnul rnul [x_0 x_1 x_2 ... x_n-1]` is the
     same as

       let
         f_-1  = lnul f_0;
         f_0   = op f_-1   x_0  f_1;
         f_1   = op f_0    x_1  f_2;
         f_2   = op f_1    x_2  f_3;
         ...
         f_n   = op f_n-1  x_n  f_n+1;
         f_n+1 = rnul f_n;
       in
         f_0
  */
  dfold = op: lnul: rnul: list:
    let
      len = builtins.length list;
      go = pred: n:
        if n == len
        then rnul pred
        else let
          # Note the cycle -- call-by-need ensures finite fold.
          cur  = op pred (builtins.elemAt list n) succ;
          succ = go cur (n + 1);
        in cur;
      lapp = lnul cur;
      cur = go lapp 0;
    in cur;

  # Take the list and disallow custom overrides in all but the final stage,
  # and allow it in the final flag. Only defaults this boolean field if it
  # isn't already set.
  withAllowCustomOverrides = lib.lists.imap1
    (index: stageFun: prevStage:
      # So true by default for only the first element because one
      # 1-indexing. Since we reverse the list, this means this is true
      # for the final stage.
      { allowCustomOverrides = index == 1; }
      // (stageFun prevStage))
    (lib.lists.reverseList stageFuns);

  # Adds the stdenv to the arguments, and sticks in it the previous stage for
  # debugging purposes.
  folder = nextStage: stageFun: prevStage: let
    args = stageFun prevStage;
    args' = args // {
      stdenv = args.stdenv // {
        # For debugging
        __bootPackages = prevStage;
        __hatPackages = nextStage;
      };
    };
    thisStage =
      if args.__raw or false
      then args'
      else allPackages ((builtins.removeAttrs args' ["selfBuild"]) // {
        adjacentPackages = if args.selfBuild or true then null else rec {
          pkgsBuildBuild = prevStage.buildPackages;
          pkgsBuildHost = prevStage;
          pkgsBuildTarget =
            if args.stdenv.targetPlatform == args.stdenv.hostPlatform
            then pkgsBuildHost
            else assert args.stdenv.hostPlatform == args.stdenv.buildPlatform; thisStage;
          pkgsHostHost =
            if args.stdenv.hostPlatform == args.stdenv.targetPlatform
            then thisStage
            else assert args.stdenv.buildPlatform == args.stdenv.hostPlatform; pkgsBuildHost;
          pkgsTargetTarget = nextStage;
        };
      });
  in thisStage;

  # This is a hack for resolving cross-compiled compilers' run-time
  # deps. (That is, compilers that are themselves cross-compiled, as
  # opposed to used to cross-compile packages.)
  postStage = buildPackages: {
    __raw = true;
    stdenv.cc =
      if buildPackages.stdenv.hasCC
      then
        if buildPackages.stdenv.cc.isClang or false
        then buildPackages.clang
        else buildPackages.gcc
      else
        # This will blow up if anything uses it, but that's OK. The `if
        # buildPackages.stdenv.cc.isClang then ... else ...` would blow up
        # everything, so we make sure to avoid that.
        buildPackages.stdenv.cc;
  };

in dfold folder postStage (_: {}) withAllowCustomOverrides
