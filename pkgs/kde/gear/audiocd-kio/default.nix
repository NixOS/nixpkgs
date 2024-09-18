{
  lib,
  mkKdeDerivation,
  cdparanoia,
  flac,
  libogg,
  libvorbis,
  substituteAll,
  lame,
  opusTools,
}:
mkKdeDerivation {
  pname = "audiocd-kio";

  patches = [
    (substituteAll {
      src = ./encoder-paths.patch;
      lame = lib.getExe lame;
      opusenc = "${opusTools}/bin/opusenc";
    })
  ];

  extraBuildInputs = [cdparanoia flac libogg libvorbis];
}
