{ stdenv, fetchurl }:

let
  mecab-base = import ./base.nix { inherit fetchurl; };
in
stdenv.mkDerivation (mecab-base // {
    name = "mecab-nodic-${mecab-base.version}";
})
