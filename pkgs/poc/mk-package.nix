{ lib, ... }@defaultPkgs:

let
  # similar to lib.extends, but we don't `//` on top of prevAttrs
  # maybe unneeded, but maybe better than lib.extends
  transforms =
    transformation: rattrs: finalAttrs:
    let
      prevAttrs = rattrs finalAttrs;
    in
    transformation finalAttrs prevAttrs;

  composeTransformations =
    f: g: # <- inputs
    final: prev:
    g final (f final prev);

  composeManyTransformations = lib.foldr composeTransformations (final: prev: prev);
in

# all builder-wrappers should implement something similar to this: transform attributes that will be passed to the builder one step below

let

  makeAdvAttrs =
    finalAttrs: prevAttrs:
    prevAttrs
    // {
      name = prevAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";

      # doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;
      # TODO: more stuff
    };

  makeStdenvAttrs =
    finalAttrs: prevAttrs:
    assert !(prevAttrs ? drvAttrs); # wrappers shouldn't set drvAttrs directly
    prevAttrs
    // {
      outputs = prevAttrs.outputs or [ "out" ]; # should we always set this?

      __pkgs = defaultPkgs;
      stdenv = prevAttrs.stdenv or finalAttrs.__pkgs.stdenv;
      builder = prevAttrs.builder or ../stdenv/generic/default-builder.sh;
      realBuilder = finalAttrs.stdenv.shell;

      drvAttrs = finalAttrs.shellVars or { } // {
        # TODO: figure out what to do about env.* and __structuredAttrs
        __structuredAttrs = false;
        inherit (finalAttrs) name outputs;
        inherit (finalAttrs.stdenv.buildPlatform) system; # don't get from stdenv
        builder = finalAttrs.realBuilder;
        args = [
          "-e"
          finalAttrs.builder
        ];
        inherit (finalAttrs) stdenv; # maybe should be part of shellVars, but it's very important, so this is probably better
      };
    };

  makeDrvAttrs =
    finalAttrs: prevAttrs:
    let
      outputs = finalAttrs.drvAttrs.outputs or [ "out" ];
      # someone should really document derivationStrict!!!
      backingDrv = builtins.derivationStrict finalAttrs.drvAttrs;
    in
    prevAttrs
    // {
      outputName = prevAttrs.outputName or (lib.head outputs);
      inherit (backingDrv) drvPath;
      outPath = backingDrv.${finalAttrs.outputName};
      type = "derivation";

      # note: since the names of outputSet depend on finalAttrs we have to use outputSet, we cannot merge with other attributes, like with mkDerivation
      outputSet = lib.listToAttrs (
        lib.map (output: {
          name = output;
          value = finalAttrs.overrideAttrs (_: _: { outputName = output; });
        }) outputs
      );
    };

in

/*
    let

      # CURRENTLY UNUSED
    # Based on lib.makeExtensible, with modifications
    makeExtensible' =
      rattrs:
      let
        overrideAttrs = f0: makeExtensible' (lib.extends (lib.toExtension f0) rattrs);

        # NOTE: The following is a hint that will be printed by the Nix cli when
        # encountering an infinite recursion. It must not be formatted into
        # separate lines, because Nix would only show the last line of the comment.

        helperAttrs = { inherit overrideAttrs; };

        # An infinite recursion here can be caused by having the attribute names of expression `e` in `.overrideAttrs(finalAttrs: previousAttrs: e)` depend on `finalAttrs`. Only the attribute values of `e` can depend on `finalAttrs`.
        finalAttrs = (rattrs finalAttrs) // helperAttrs;
      in
      finalAttrs;
  in
*/

let
  mkPackage =
    rattrs:
    let
      combinedTransformation = composeManyTransformations [
        makeAdvAttrs
        makeStdenvAttrs
        makeDrvAttrs
      ];

      rattrs' = transforms combinedTransformation rattrs;
    in

    lib.makeExtensibleWithCustomName "overrideAttrs" rattrs';
in

mkPackage
