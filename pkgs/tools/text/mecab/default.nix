{ stdenv, fetchurl, mecab-ipadic }:

let
  mecab-base = import ./base.nix { inherit fetchurl; };
in
stdenv.mkDerivation (mecab-base // {
    name = "mecab-${mecab-base.version}";

    postInstall = ''
      sed -i 's|^dicdir = .*$|dicdir = ${mecab-ipadic}|' "$out/etc/mecabrc"
    '';

    meta = with stdenv.lib; {
      description = "Japanese morphological analysis system";
      homepage = http://taku910.github.io/mecab/;
      license = licenses.bsd3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ auntie ];
    };
})
