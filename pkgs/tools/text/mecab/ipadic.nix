{ stdenv, fetchurl, mecab-nodic }:

stdenv.mkDerivation rec {
  name = "mecab-ipadic-${version}";
  version = "2.7.0-20070801";

  src = fetchurl {
    url = https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM;
    name = "mecab-ipadic-2.7.0-20070801.tar.gz";
    sha256 = "08rmkvj0f0x6jq0axrjw2y5nam0mavv6x77dp9v4al0wi1ym4bxn";
  };

  buildInputs = [ mecab-nodic ];

  configurePhase = ''
    ./configure --with-dicdir="$out"
  '';
}
