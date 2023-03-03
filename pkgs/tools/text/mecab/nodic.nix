{ stdenv, fetchurl }:

let
  mecab-base = import ./base.nix { inherit fetchurl; };
in
stdenv.mkDerivation (mecab-base // {
    pname = "mecab-nodic";
    version = mecab-base.version;
})
