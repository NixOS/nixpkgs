{ lib, mkBaseDerivation, ... }:

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

  # opinion:
  # stdenv.*Platform should probably not be part of stdenv, but part of pkgs
  # perhaps something like pkgs.platforms.{build,host,target}

  # takes in the finalAttrs of a package and outputs what the inputs of `derivation` should be
  mkAttrsForRealDrv =
    {
      name,
      outputs,
      shellVars,
      stdenv,
      realBuilder,
      args,
      ...
    }:

    ## TODO: don't allow special values in shellVars or envVars
    {
      __structuredAttrs = false; # TODO
      inherit name outputs;
      inherit (stdenv.buildPlatform) system; # don't get from stdenv
      builder = realBuilder;
      inherit args;
    }
    // shellVars; # TODO: __structuredAttrs & .env

  # all builder-wrappers should implement something similar to this: transform attributes that will be passed to the builder one step below
  transformAttrs =
    finalAttrs: prevAttrs:
    {
      # TODO: perhaps these kinds of default values have unoptimal error messages
      name = "${finalAttrs.pname}-${finalAttrs.version}";
      outputs = [ "out" ];
      doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;

      realBuilder = finalAttrs.stdenv.shell;
      builder = ../stdenv/generic/default-builder.sh;
      inherit (finalAttrs.__pkgs) stdenv;

      args = [
        "-e"
        finalAttrs.builder
      ];
    }
    // prevAttrs
    // {
      shellVars = prevAttrs.shellVars // {
        inherit (finalAttrs) stdenv;
      };
    };

in

let
  mkPackage =
    rattrs:
    let
      rattrs' = transforms transformAttrs rattrs;
    in
    mkBaseDerivation mkAttrsForRealDrv rattrs';
in
mkPackage
