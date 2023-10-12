{ stdenv, fetchurl, mecab-nodic }:

stdenv.mkDerivation (finalAttrs: {
  pname = "mecab-ipadic";
  version = "2.7.0-20070801";

  src = fetchurl {
    url = "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM";
    name = "mecab-ipadic-${finalAttrs.version}.tar.gz";
    hash = "sha256-ti9SfYgcUEV2uu2cbvZWFVRlixdc5q4AlqYDB+SeNSM=";
  };

  buildInputs = [ mecab-nodic ];

  configureFlags = [
    "--with-charset=utf8"
    "--with-dicdir=${placeholder "out"}"
  ];
})
