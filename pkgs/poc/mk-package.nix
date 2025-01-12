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

let

  layer3ToLayer2 =
    { layer0Attrs, ... }:
    prevAttrs:
    prevAttrs
    // {
      name = prevAttrs.name or "${layer0Attrs.pname}-${layer0Attrs.version}";

      # doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;
      # TODO: more stuff
    };

  layer2ToLayer1 =
    { layer0Attrs, ... }:
    prevAttrs:
    assert !(prevAttrs ? drvAttrs); # wrappers shouldn't set drvAttrs directly
    prevAttrs
    // {
      outputs = prevAttrs.outputs or [ "out" ]; # should we always set this?

      __pkgs = defaultPkgs;
      stdenv = prevAttrs.stdenv or layer0Attrs.__pkgs.stdenv;
      builder = prevAttrs.builder or ../stdenv/generic/default-builder.sh;
      realBuilder = layer0Attrs.stdenv.shell;

      drvAttrs = layer0Attrs.shellVars or { } // {
        # TODO: figure out what to do about env.* and __structuredAttrs
        __structuredAttrs = false;
        inherit (layer0Attrs) name outputs;
        inherit (layer0Attrs.stdenv.buildPlatform) system; # don't get from stdenv
        builder = layer0Attrs.realBuilder;
        args = [
          "-e"
          layer0Attrs.builder
        ];
        inherit (layer0Attrs) stdenv; # maybe should be part of shellVars, but it's very important, so this is probably better
      };
    };

  layer1ToLayer0 =
    { layer0Attrs, ... }:
    prevAttrs:
    let
      outputs = layer0Attrs.drvAttrs.outputs or [ "out" ];
      # someone should really document derivationStrict!!!
      backingDrv = builtins.derivationStrict layer0Attrs.drvAttrs;
    in
    prevAttrs
    // {
      outputName = prevAttrs.outputName or (lib.head outputs);
      inherit (backingDrv) drvPath;
      outPath = backingDrv.${layer0Attrs.outputName};
      type = "derivation";

      # note: since the names of outputSet depend on finalAttrs we have to use outputSet, we cannot merge with other attributes, like with mkDerivation
      outputSet = lib.listToAttrs (
        lib.map (output: {
          name = output;
          value = layer0Attrs.overrideLayer0 (_: prev: prev // { outputName = output; });
        }) outputs
      );
    };

in

let

  makeExtensible' =
    {
      layer3ExtraTransformation ? (final: prev: prev),
      layer2ExtraTransformation ? (final: prev: prev),
      layer1ExtraTransformation ? (final: prev: prev),
      layer0ExtraTransformation ? (final: prev: prev),
    }:
    origRattrs:
    let
      # maybe dont expand usage of 'transforms'

      startLayer3Attrs = origRattrs layerAttrsSet;
      finalLayer3Attrs = layer3ExtraTransformation layerAttrsSet startLayer3Attrs // visibleHelperAttrs;

      startLayer2Attrs = layer3ToLayer2 layerAttrsSet finalLayer3Attrs;
      finalLayer2Attrs = layer2ExtraTransformation layerAttrsSet startLayer2Attrs // visibleHelperAttrs;

      startLayer1Attrs = layer2ToLayer1 layerAttrsSet finalLayer2Attrs;
      finalLayer1Attrs = layer1ExtraTransformation layerAttrsSet startLayer1Attrs // visibleHelperAttrs;

      startLayer0Attrs = layer1ToLayer0 layerAttrsSet finalLayer1Attrs;
      finalLayer0Attrs = layer0ExtraTransformation layerAttrsSet startLayer0Attrs // visibleHelperAttrs;

      # TODO: decide if layers should have access to all layers or just the ones below
      layerAttrsSet = {
        layer3Attrs = finalLayer3Attrs;
        layer2Attrs = finalLayer2Attrs;
        layer1Attrs = finalLayer1Attrs;
        layer0Attrs = finalLayer0Attrs;
      };

      visibleHelperAttrs = {
        inherit
          overrideLayer3
          overrideLayer2
          overrideLayer1
          overrideLayer0
          ;
      };

      extraTransformations = {
        inherit
          layer3ExtraTransformation
          layer2ExtraTransformation
          layer1ExtraTransformation
          layer0ExtraTransformation
          ;
      };

      makeSelfWithModifiedExtra = modExtra: makeExtensible' (extraTransformations // modExtra) origRattrs;

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

    in
    finalLayer0Attrs;
in

let
  mkPackage = rattrs: makeExtensible' { } rattrs;
in

mkPackage
