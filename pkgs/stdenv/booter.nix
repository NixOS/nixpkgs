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

  # Take the list and disallow custom overrides in all but the final stage,
  # and allow it in the final flag. Only defaults this boolean field if it
  # isn't already set.
  withAllowCustomOverrides = lib.lists.imap
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
  in
    if args.__raw or false
    then args'
    else allPackages ((builtins.removeAttrs args' ["selfBuild"]) // {
      buildPackages = if args.selfBuild or true then null else prevStage;
      __targetPackages = if args.selfBuild or true then null else nextStage;
    });

in lib.lists.dfold folder {} {} withAllowCustomOverrides
