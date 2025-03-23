{
  lib,
  mkKdeDerivation,
  cdparanoia,
  flac,
  libogg,
  libvorbis,
  replaceVars,
  lame,
  opusTools,
}:
mkKdeDerivation {
  pname = "audiocd-kio";

  patches = [
    (replaceVars ./encoder-paths.patch {
      lame = lib.getExe lame;
      opusenc = "${opusTools}/bin/opusenc";
    })
  ];

  extraBuildInputs = [
    cdparanoia
    flac
    libogg
    libvorbis
  ];
}
