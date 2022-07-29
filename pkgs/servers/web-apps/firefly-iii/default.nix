{ pkgs, stdenv, lib, fetchFromGitHub }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true;
  });
in
  package.override rec {
    pname = "firefly-iii";
    version = "5.7.18";

    src = fetchFromGitHub {
      owner = "firefly-iii";
      repo = pname;
      rev = version;
      sha256 = "0rrcfhmb7rzi4m5sl99gkl2hijdlncpihirk5lw2v8k9fhb90b8a";
    };
  }
