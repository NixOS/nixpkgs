{ lib, ... }@defaultPkgs:

let
  # pass argsForRealDrv to derivation, but remove non-essential attrNames, and overlay the extraAttrs attrset instead
  mkBaseDerivationSimple =
    argsForRealDrv: extraAttrs:
    let
      drv = derivation argsForRealDrv; # TODO: maybe pass drv in instead of just the args
    in

    let

      stripDrv = drvOutput: {
        inherit (drvOutput)
          name
          outputs
          system
          drvPath
          outPath
          outputName
          drvAttrs
          type
          ;
      };

      outputToAttrListElement = outputName: {
        name = outputName;
        value =
          commonAttrs
          // stripDrv drv.${outputName}
          // {
            outputSpecified = true; # used by lib.getOutput
          }
          //
            # TODO: give the derivation control over the outputs.
            #       `overrideAttrs` may not be the only attribute that needs
            #       updating when switching outputs.
            lib.optionalAttrs (extraAttrs ? overrideAttrs) {
              # TODO: also add overrideAttrs when overrideAttrs is not custom, e.g. when not splicing.
              overrideAttrs = f: (extraAttrs.overrideAttrs f).${outputName};
            };
      };

      outputsAttrset = lib.listToAttrs (map outputToAttrListElement drv.outputs);
      commonAttrs = outputsAttrset // { all = builtins.attrValues outputsAttrset; } // extraAttrs;
    in
    commonAttrs
    // stripDrv drv
    // {
      outputSpecified = false; # unneeded, but maybe keep
    };

  # Based on lib.makeExtensible, with modifications:
  mkBaseDerivationExtensible =
    mkArgsForRealDrv: rattrs:
    let
      overrideAttrs =
        f0: mkBaseDerivationExtensible mkArgsForRealDrv (lib.extends (lib.toExtension f0) rattrs);

      helperAttrs = {
        inherit finalPackage overrideAttrs;
        __pkgs = defaultPkgs;
      };

      # NOTE: The following is a hint that will be printed by the Nix cli when
      # encountering an infinite recursion. It must not be formatted into
      # separate lines, because Nix would only show the last line of the comment.

      # An infinite recursion here can be caused by having the attribute names of expression `e` in `.overrideAttrs(finalAttrs: previousAttrs: e)` depend on `finalAttrs`. Only the attribute values of `e` can depend on `finalAttrs`.
      args = (rattrs args) // helperAttrs;
      #              ^^^^

      # TODO: the infrec marker above is no longer near the front of the error stack
      finalPackage = mkBaseDerivationSimple (mkArgsForRealDrv args) args;
    in
    finalPackage;
in
mkBaseDerivationExtensible
