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
  # all builder-wrappers should implement something similar to this: transform attributes that will be passed to the builder one step below
  transformAttrs =
    finalAttrs: prevAttrs:
    {
      outputs = [ "out" ];
      doCheck = finalAttrs.stdenv.buildPlatform.canExecute finalAttrs.stdenv.hostPlatform;
      envVars = { };

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
        inherit (finalAttrs) name stdenv;
      };
    };

in
rattrs: mkBaseDerivation (transforms transformAttrs rattrs)
