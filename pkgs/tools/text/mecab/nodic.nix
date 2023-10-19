{ stdenv, fetchurl }:

let
  mecab-base = import ./base.nix { inherit fetchurl; };
in
stdenv.mkDerivation (finalAttrs: ((mecab-base finalAttrs) // {
  pname = "mecab-nodic";
}))
