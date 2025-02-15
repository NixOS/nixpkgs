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

  # inherit the listed names of an attrset into an new attrset, but only if the name actually exists
  takeAttrs = names: lib.filterAttrs (n: _: lib.elem n names);
in

let

  layer3ToLayer2 =
    { finalAttrs, ... }:
    prevAttrs:
    prevAttrs
    // {
      name = prevAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";

      # NOTE: these things below should probably be part of the layer below, or a new layer separately, since they are very stdenv-centric

      # should we do prevAttrs.doCheck && canExecute (like with mkDerivation) or should we just trust prevAttrs to also do canExecute manually
      doCheck =
        prevAttrs.doCheck or (finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform);

      doInstallCheck =
        prevAttrs.doInstallCheck
          or (finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform);

      # should we do this? IMO this logic should be done by the consumer, manually
      nativeBuildInputs =
        prevAttrs.nativeBuildInputs or [ ]
        ++ lib.optionals finalAttrs.doCheck (finalAttrs.nativeCheckInputs or [ ])
        ++ lib.optionals finalAttrs.doInstallCheck (finalAttrs.nativeInstallCheckInputs or [ ]);

      buildInputs =
        prevAttrs.buildInputs or [ ]
        ++ lib.optionals finalAttrs.doCheck (finalAttrs.checkInputs or [ ])
        ++ lib.optionals finalAttrs.doInstallCheck (finalAttrs.installCheckInputs or [ ]);

      shellVars =
        prevAttrs.shellVars or { }
        // takeAttrs [
          "pname"
          "version"
          "src"
          "srcs"
          "sourceRoot"
          "nativeBuildInputs"
          "buildInputs"
          "nativeCheckInputs"
          "checkInputs"
          "doCheck"
          "doInstallCheck"
          "env"
          "preUnpack"
          "unpackPhase"
          "postUnpack"
          "prePatch"
          "patchPhase"
          "postPatch"
          "preConfigure"
          "configurePhase"
          "postConfigure"
          "preBuild"
          "buildPhase"
          "postBuild"
          "preInstall"
          "installPhase"
          "postInstall"
          "preFixup"
          "fixupPhase"
          "postFixup"
        ] finalAttrs;
    };

  layer2ToLayer1 =
    { finalAttrs, ... }:
    prevAttrs:
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
    { finalAttrs, ... }:
    prevAttrs:
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
          value = finalAttrs.overrideAttrs (_: prev: prev // { outputName = output; });
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
      origLayer3Attrs = origRattrs layerAttrsSet;
      finalLayer3Attrs = layer3ExtraTransformation layerAttrsSet origLayer3Attrs // helperAttrs;

      origLayer2Attrs = layer3ToLayer2 layerAttrsSet finalLayer3Attrs;
      finalLayer2Attrs = layer2ExtraTransformation layerAttrsSet origLayer2Attrs // helperAttrs;

      origLayer1Attrs = layer2ToLayer1 layerAttrsSet finalLayer2Attrs;
      finalLayer1Attrs = layer1ExtraTransformation layerAttrsSet origLayer1Attrs // helperAttrs;

      origLayer0Attrs = layer1ToLayer0 layerAttrsSet finalLayer1Attrs;
      finalLayer0Attrs = layer0ExtraTransformation layerAttrsSet origLayer0Attrs // helperAttrs;

      # TODO: decide if we should ever reference anything other than layer0Attrs/finalAttrs
      # (multiple sources of truth are bad)
      # (which layer should the consumer override when a value is just inherited?)
      # (or more imporantly, which layer should a layer->layer transformer reference?)
      # # (maybe the lowest layer the value still exists in (usually layer0))
      # (this should probably be discouraged, but currently there are situations like with buildRustPackage, when the uppermost layer's attribute names are unprefixed, but converted to a prefixed version later: e.g buildType -> cargoBuildType)

      # TODO: decide if layers should have access to all layers or just the ones below
      layerAttrsSet = {
        layer3Attrs = finalLayer3Attrs;
        layer2Attrs = finalLayer2Attrs;
        layer1Attrs = finalLayer1Attrs;
        layer0Attrs = finalLayer0Attrs;
        finalAttrs = finalLayer0Attrs;
      };

      # these would still be useful even if they were only able to reference layer0Attrs/finalAttrs
      helperAttrs = {
        inherit
          overrideLayer3
          overrideLayer2
          overrideLayer1
          overrideLayer0
          ;
        overrideAttrs = overrideLayer0; # IMPORTANT: currently implemented in terms of transformations and not extensions (meaning you have to do `prevAttrs //` manually)
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
