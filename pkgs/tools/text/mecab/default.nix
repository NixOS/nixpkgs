{ lib, stdenv, fetchurl, mecab-ipadic }:

let
  mecab-base = import ./base.nix { inherit fetchurl; };
in
stdenv.mkDerivation (finalAttrs: ((mecab-base finalAttrs) // {
  pname = "mecab";

  postInstall = ''
    sed -i 's|^dicdir = .*$|dicdir = ${mecab-ipadic}|' "$out/etc/mecabrc"
  '';

  meta = with lib; {
    description = "Japanese morphological analysis system";
    homepage = "http://taku910.github.io/mecab";
    license = licenses.bsd3;
    platforms = platforms.unix;
    mainProgram = "mecab";
    maintainers = with maintainers; [ auntie paveloom ];
  };
}))
