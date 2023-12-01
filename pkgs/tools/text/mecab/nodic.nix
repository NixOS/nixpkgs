{ stdenv, fetchurl, libiconv }:

let
  mecab-base = import ./base.nix { inherit fetchurl libiconv; };
in
stdenv.mkDerivation (finalAttrs: ((mecab-base finalAttrs) // {
  pname = "mecab-nodic";
}))
