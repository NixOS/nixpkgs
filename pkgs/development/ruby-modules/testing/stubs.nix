{ stdenv, lib, ruby, callPackage, ... }:
let
  real = {
    inherit (stdenv) mkDerivation;
  };
  mkDerivation = {name, ...}@argSet:
  derivation {
    inherit name;
    text = (builtins.toJSON (lib.filterAttrs ( n: v: builtins.any (x: x == n) ["name" "system"]) argSet));
    builder = stdenv.shell;
    args = [ "-c" "echo  $(<$textPath) > $out"];
    system = stdenv.system;
    passAsFile = ["text"];
  };
  fetchurl = {url?"", urls ? [],...}: "fetchurl:${if urls == [] then url else builtins.head urls}";

  stdenv' = stdenv // {
    inherit mkDerivation;
    stubbed = true;
  };
  ruby' = ruby // {
    stdenv = stdenv';
    stubbed = true;
  };
in
  {
    ruby = ruby';
    buildRubyGem = callPackage ../gem {
      inherit fetchurl;
      ruby = ruby';
    };
    stdenv = stdenv';
  }
