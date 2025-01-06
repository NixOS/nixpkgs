{ lib, ... }@defaultPkgs: # this should be pkgs aka. pkgsHostTarget

# opinion:
# stdenv.*Platform should probably not be part of stdenv, but part of pkgs
# perhaps something like pkgs.platforms.{build,host,target}

let
  # similar to lib.extends, but we don't `//` on top of prevAttrs
  transforms =
    transformation: rattrs: finalAttrs:
    let
      prevAttrs = rattrs finalAttrs;
    in
    transformation finalAttrs prevAttrs;

in

let
  # Based on lib.makeExtensible, with modifications:
  mkBaseDerivationExtensible =
    rattrs:
    let
      overrideAttrs = f0: mkBaseDerivationExtensible (lib.extends (lib.toExtension f0) rattrs);

      # NOTE: The following is a hint that will be printed by the Nix cli when
      # encountering an infinite recursion. It must not be formatted into
      # separate lines, because Nix would only show the last line of the comment.

      # An infinite recursion here can be caused by having the attribute names of expression `e` in `.overrideAttrs(finalAttrs: previousAttrs: e)` depend on `finalAttrs`. Only the attribute values of `e` can depend on `finalAttrs`.
      args = rattrs (args // { inherit finalPackage; });
      #              ^^^^
      # TODO: should overrideAttrs come before or after args?
      finalPackage = mkBaseDerivationSimple ({ inherit overrideAttrs; } // args);
    in
    finalPackage;

  # removes the non-essential attributes from all outputs of a plain derivation and overlays the extraAttrs attrset instead
  populatePlainDerivation =
    drv: extraAttrs:
    let
      stripDrv = drv: {
        inherit (drv)
          name
          outputs
          builder
          args
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

  mkBaseDerivationSimple =
    inputAttrs':

    let
      inputAttrs =
        assert true; # TODO: assert envVars only contains string, bool, number or derivation
        inputAttrs';

      mkAttrsForPlainDrv =
        {
          name,
          outputs,
          shellVars,
          envVars,
          stdenv,
          ...
        }@attrs:

        ## TODO: don't allow special values in shellVars or envVars
        {
          __structuredAttrs = false; # TODO
          inherit name outputs;
          inherit (stdenv.buildPlatform) system;
          builder = attrs.realBuilder or attrs.stdenv.shell;
          args =
            attrs.args or [
              "-e"
              (attrs.builder or ../pkgs/stdenv/generic/default-builder.sh)
            ];
        }
        // shellVars
        // envVars # TODO: __structuredAttrs
      ;

      plainDrv = derivation (mkAttrsForPlainDrv inputAttrs);
    in
    populatePlainDerivation plainDrv inputAttrs;
in

let

  # all builder-wrappers should implement something similar to this: transform attributes that will be passed to the builder one step below
  transformAttrs =
    finalAttrs: prevAttrs:
    {
      inherit (finalAttrs.__pkgs) stdenv;
      outputs = [ "out" ];
      doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;
      envVars = { };
      __pkgs = defaultPkgs;
    }
    // prevAttrs
    // {
      shellVars = prevAttrs.shellVars // {
        inherit (finalAttrs) name stdenv;
      };
    };

  mkDerivation = rattrs: mkBaseDerivationExtensible (transforms transformAttrs rattrs);
in
mkDerivation
