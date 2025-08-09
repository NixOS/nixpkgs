# This expression will, as efficiently as possible, dump a
# *superset* of all attrpaths of derivations which might be
# part of a release on *any* platform.
#
# Both this expression and what ofborg uses (release-outpaths.nix)
# are essentially single-threaded (under the current cppnix
# implementation).
#
# This expression runs much, much, much faster and uses much, much
# less memory than the ofborg script by skipping the
# platform-relevance checks.  The ofborg outpaths.nix script takes
# half an hour on a 3ghz core and peaks at 60gbytes of memory; this
# expression runs on the same machine in 44 seconds with peak memory
# usage of 5gbytes.
#
# Once you have the list of attrnames you can split it up into
# $NUM_CORES batches and run the platform checks separately for each
# batch, in parallel.
#
# To dump the attrnames:
#
#   nix-instantiate --eval --strict --json pkgs/top-level/release-attrpaths-superset.nix -A names
#
{
  lib ? import (path + "/lib"),
  trace ? false,
  checkMeta ? true,
  path ? ./../..,
}:
let

  # The intended semantics are that an attrpath rooted at pkgs is
  # part of the (unfiltered) release jobset iff both of the following
  # are true:
  #
  # 1. The attrpath leads to a value for which lib.isDerivation is true
  #
  # 2. Any proper prefix of the attrpath at which lib.isDerivation
  #    is true also has __recurseIntoDerivationForReleaseJobs=true.
  #
  # The second condition is unfortunately necessary because there are
  # Hydra release jobnames which have proper prefixes which are
  # attrnames of derivations (!).  We should probably restructure
  # the job tree so that this is not the case.
  #
  justAttrNames =
    path: value:
    let
      result =
        if path == [ "AAAAAASomeThingsFailToEvaluate" ] then
          [ ]
        else if
          lib.isDerivation value
          &&
            # in some places we have *derivations* with jobsets as subattributes, ugh
            !(value.__recurseIntoDerivationForReleaseJobs or false)
        then
          [ path ]

        # Even wackier case: we have meta.broken==true jobs with
        # !meta.broken jobs as subattributes with license=unfree, and
        # check-meta.nix won't throw an "unfree" failure because the
        # enclosing derivation is marked broken.  Yeah.  Bonkers.
        # We should just forbid jobsets enclosed by derivations.
        else if lib.isDerivation value && !value.meta.available then
          [ ]

        else if !(lib.isAttrs value) then
          [ ]
        else
          lib.pipe value [
            (builtins.mapAttrs (
              name: value:
              builtins.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ name ])
              }'" (justAttrNames (path ++ [ name ]) value)
            ))
            builtins.attrValues
            builtins.concatLists
          ];
    in
    if !trace then result else lib.trace "** ${lib.concatStringsSep "." path}" result;

  releaseOutpaths = import ./release-outpaths.nix {
    inherit checkMeta;
    attrNamesOnly = true;
    inherit path;
  };

  paths = [
    # I am not entirely sure why these three packages end up in
    # the Hydra jobset.  But they do, and they don't meet the
    # criteria above, so at the moment they are special-cased.
    [
      "pkgsLLVM"
      "stdenv"
    ]
    [
      "pkgsStatic"
      "stdenv"
    ]
    [
      "pkgsMusl"
      "stdenv"
    ]
  ]
  ++ justAttrNames [ ] releaseOutpaths;

  names = map (path: (lib.concatStringsSep "." path)) paths;

in
{
  inherit paths names;
}
