{
  lib,
  mkKdeDerivation,
  libkcompactdisc,
  cdparanoia,
  flac,
  libogg,
  libvorbis,
  replaceVars,
  lame,
  opus-tools,
}:
mkKdeDerivation {
  pname = "audiocd-kio";

  patches = [
    (replaceVars ./encoder-paths.patch {
      lame = lib.getExe lame;
      opusenc = "${opus-tools}/bin/opusenc";
    })
  ];

  extraBuildInputs = [
    libkcompactdisc

    cdparanoia
    flac
    libogg
    libvorbis
  ];
}
