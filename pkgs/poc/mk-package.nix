{ lib, ... }@defaultPkgs:

let
  # similar to lib.extends, but we don't `//` on top of prevAttrs
  # maybe unneeded, but maybe better than lib.extends
  transforms =
    transformation: rattrs: finalAttrs:
    transformation finalAttrs (rattrs finalAttrs);

  composeTransformations =
    f: g: # <- inputs
    final: prev:
    g final (f final prev);

  composeManyTransformations = lib.foldr composeTransformations (final: prev: prev);
in

# all builder-wrappers should implement something similar to this: transform attributes that will be passed to the builder one step below

let

  layer3ToLayer2 =
    finalAttrs: prevAttrs:
    prevAttrs
    // {
      name = prevAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";

      # doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;
      # TODO: more stuff
    };

  layer2ToLayer1 =
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

  layer1ToLayer0 =
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

let

  makeExtensible' =
    origRattrs:
    {
      layer3ExtraTransformation ? (final: prev: prev),
      layer2ExtraTransformation ? (final: prev: prev),
      layer1ExtraTransformation ? (final: prev: prev),
      layer0ExtraTransformation ? (final: prev: prev),
    }:
    let
      # maybe dont expand usage of 'transforms'
      rattrs3 = origRattrs;
      rattrs3' = finalAttrs: layer3ExtraTransformation finalAttrs (rattrs3 finalAttrs);
      finalLayer3Attrs = rattrs3' (finalLayer3Attrs // invisibleHelperAttrs) // visibleHelperAttrs;

      rattrs2 = finalAttrs: layer3ToLayer2 finalAttrs finalLayer3Attrs;
      rattrs2' = finalAttrs: layer2ExtraTransformation finalAttrs (rattrs2 finalAttrs);
      finalLayer2Attrs = rattrs2' (finalLayer2Attrs // invisibleHelperAttrs) // visibleHelperAttrs;

      rattrs1 = finalAttrs: layer2ToLayer1 finalAttrs finalLayer2Attrs;
      rattrs1' = finalAttrs: layer1ExtraTransformation finalAttrs (rattrs1 finalAttrs);
      finalLayer1Attrs = rattrs1' (finalLayer1Attrs // invisibleHelperAttrs) // visibleHelperAttrs;

      rattrs0 = finalAttrs: layer1ToLayer0 finalAttrs finalLayer1Attrs;
      rattrs0' = finalAttrs: layer1ExtraTransformation finalAttrs (rattrs0 finalAttrs);
      finalLayer0Attrs = rattrs0' (finalLayer0Attrs // invisibleHelperAttrs) // visibleHelperAttrs;

      extraTransformations = {
        inherit
          layer3ExtraTransformation
          layer2ExtraTransformation
          layer1ExtraTransformation
          layer0ExtraTransformation
          ;
      };

      makeSelfWithModifiedExtra = modExtra: makeExtensible' origRattrs (extraTransformations // modExtra);

      overrideLayer3 =
        transformation:
        makeSelfWithModifiedExtra {
          layer3ExtraTransformation = composeTransformations layer3ExtraTransformation transformation;
        };

      overrideLayer2 =
        transformation:
        makeSelfWithModifiedExtra {
          layer2ExtraTransformation = composeTransformations layer2ExtraTransformation transformation;
        };

      overrideLayer1 =
        transformation:
        makeSelfWithModifiedExtra {
          layer1ExtraTransformation = composeTransformations layer1ExtraTransformation transformation;
        };

      overrideLayer0 =
        transformation:
        makeSelfWithModifiedExtra {
          layer0ExtraTransformation = composeTransformations layer0ExtraTransformation transformation;
        };

      invisibleHelperAttrs = {
        inherit
          finalLayer3Attrs
          finalLayer2Attrs
          finalLayer1Attrs
          finalLayer0Attrs
          ;
      };

      visibleHelperAttrs = {
        inherit
          overrideLayer3
          overrideLayer2
          overrideLayer1
          overrideLayer0
          ;
      };

    in
    finalLayer0Attrs;
in

let
  mkPackage = rattrs: makeExtensible' rattrs { };
in

mkPackage
