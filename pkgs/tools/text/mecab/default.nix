{ lib, stdenv, fetchurl, mecab-ipadic, libiconv }:

let
  mecab-base = import ./base.nix { inherit fetchurl libiconv; };
in
stdenv.mkDerivation (finalAttrs: ((mecab-base finalAttrs) // {
  pname = "mecab";

  postInstall = ''
    mkdir -p $out/lib/mecab/dic
    ln -s ${mecab-ipadic} $out/lib/mecab/dic/ipadic
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
