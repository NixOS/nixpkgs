# ABI compatible patches are made based on one assumption, which is that
# Nixpkgs is a function which provide a set of derivation, where all the
# dependencies are taken from its argument. This hypothesis has to hold,
# in order to make it possible to override packages.
#
# Unfortunately, they are many ways in which a dependency can be defined,
# and it could be defined after multiple iterations through the Nixpkgs
# function, or at the same iteration.
#
# This file is made to analyze and report issues in the resolutions of
# dependencies such that we can generate safe security updates.

with import ./lib.nix;

let
  # Load Nixpkgs without any additional wrapping.
  pkgsFun = pkgs.__unfix__;

  # These attributes are unrolling the fix-point of Nixpkgs over a few
  # numbers of iteration, and all derivations of each iteration are annotated
  # with their generation number.
  #
  # Such annotations are useful to analyze the data-flow of the derivations,
  # and to find issues which are not safe for applying ABI compatible
  # patches.
  rangeMax = 10;
  genPkgs = with lib;
    let generations = range 0 rangeMax; in
      fold (gen: pkgs: annotatePkgs gen (pkgsFun pkgs)) pkgs generations;

  # Annotate all derivations with an extra attribute, named `_generation`.
  # This extra attribute identify all packages coming from this layer of
  # Nixpkgs. This is used to track attributes which are not handled by the
  # applyAbiCompatiblePatches function.
  annotatePkgs = generation: pkgs: with lib;
    let
      recursiveAnnotateValue = attrs:
        mapAttrsRecursiveCond
          (as: !isDerivation as) (path: maybeAnnotateValue path)
          attrs;

      # We don't want to patch callPackages, but the override function
      # returned by it.
      validFunctionName = path:
        let funName = elemAt path (length path - 1); in
          ! elem funName [ "newScope" "callPackage" "callPackages" "callPackage_i686" "mkDerivation" ];

      annotateValue = path: value:
        if isDerivation value then
          # assert __trace (strict ["annotatePkgs::" generation] ++ path) true;
          (mapAttrs (name: maybeAnnotateValue (path ++ [".drv" name])) value)
          // {
            _generation =
              if value ? _generation then value._generation
              else
                # assert __trace (strict ["annotatePkgs>>" generation] ++ path) true;
                generation;
          }
        else if isFunction value && validFunctionName path then
          x: maybeAnnotateValue (path ++ [">"]) (value x)
        else
          value;

      maybeAnnotateValue = path: value:
        let res = builtins.tryEval (annotateValue path value); in
        if res.success then res.value
        else value;
    in
      recursiveAnnotateValue pkgs;

  # This is a clone of the recursive update function, which is made lazier,
  # by not evaluating the left-hand-side. Thus, avoid being strict on
  # derivations.
  recursiveUpdate = lhs: rhs: with lib;
    recursiveUpdateUntil (path: lhs: rhs: !isAttrs rhs) lhs rhs;

  # Do not waste time looking for derivations which might cause us trouble,
  # either by causing infinite loops or simply by taking too much time to
  # visit.
  filteredPkgs = recursiveUpdate genPkgs {

    # Prevent infinite recursions within the following attributes:
    allStdenvs = null;
    pkgs = null;
    pkgsi686Linux = null;
    gnome3.gnome3 = null;
    lispPackages.pkgs = null;

    # Prevent errors not caught by builtins.tryEval.
    darwin.CF_new = null;
    darwin.Libc_new = null;
    darwin.Libnotify_new = null;
    darwin.Libsystem_new = null;
    darwin.cctools_cross = null;
    darwin.libdispatch_new = null;
    darwin.libiconv_new = null;
    darwin.objc4_new = null;
    darwin.xnu_new = null;

    linuxPackages_3_10_tuxonice = null;
    nodePackages.by-spec.pure-css = null;

    # Call me lazy...
    recurseForDerivations = true;
  };

  # Look at the collected derivations, and annotate each derivation with
  # some errors/warnings that should be considered. Filter out any
  # derivation which does not represent a risk for applying security
  # updates.
  analyzePackages = with lib;
    let
      getGeneration = dft: drv: drv._generation or dft;
      inputsByGeneration = dft: gen: drv:
        filter (d: isDerivation d && getGeneration dft d == gen) (drv.nativeBuildInputs or []);
      inputsOlderThanGeneration = dft: gen: drv:
        filter (d: isDerivation d && getGeneration dft d > gen) (drv.nativeBuildInputs or []);

      analyze = {path, value}@elem:
        rec {
          generation = getGeneration rangeMax value;
          inputs-by-generations = {
            gen0 = inputsByGeneration generation 0 value;
            gen1 = inputsByGeneration generation 1 value;
            old = inputsOlderThanGeneration generation 1 value;
          };
          messages = []
          ++ optional (generation != 0) "alias-original: generation ${toString generation}"
          ++ optional (inputs-by-generations.old != []) ''unpatched-inputs: generation ${toString generation}, inputs: ${
               concatStringsSep ", " (map (d: "(${toString (getGeneration generation d)}, ${d.outPath})") inputs-by-generations.old)
             }''
          ++ optional (inputs-by-generations.gen0 != []) ''static-linking: generation ${toString generation}, inputs: ${
               concatStringsSep ", " (map (d: "(${toString (getGeneration generation d)}, ${d.outPath})") inputs-by-generations.gen0)
             }'';
        };

      addMessages = e: e // analyze e;
    in
      filter (e: e.messages != []) (
        map addMessages (collectDerivations filteredPkgs));

  # Debug function which prints the list of known issues which can be
  # checked statically.
  displayAnalysis = issues: with lib;
    let
      displayMessages = e:
        map (m: "${e.path}: ${m}") e.messages;
      allMessages =
        concatMap displayMessages issues;
    in
    assert __trace (''List of ${toString (length allMessages)} potential issues:

    '' + concatStringsSep "\n" allMessages
    ) true;
    null;

in
  displayAnalysis analyzePackages
