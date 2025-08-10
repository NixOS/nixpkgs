{
  lib,
  stdenv,
  fetchurl,
  mecab-nodic,
  buildPackages,
}:

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
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--with-mecab-config=${lib.getExe' buildPackages.mecab "mecab-config"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--with-mecab-config=${lib.getExe' (lib.getDev mecab-nodic) "mecab-config"}"
  ];
})
