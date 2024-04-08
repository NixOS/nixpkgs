{
  lib,
  mkKdeDerivation,
  pkg-config,
  qtwebengine,
  shared-mime-info,
  libdvdread,
  flac,
  libmad,
  libsndfile,
  lame,
  libvorbis,
  libsamplerate,
  cdrdao,
  cdrtools,
  dvdplusrwtools,
  libburn,
  normalize,
  sox,
  transcode,
  vcdimager,
}:
mkKdeDerivation {
  pname = "k3b";

  extraNativeBuildInputs = [pkg-config shared-mime-info];

  # FIXME: Musicbrainz 2.x???, musepack
  extraBuildInputs = [
    qtwebengine
    libdvdread
    flac
    libmad
    libsndfile
    lame
    libvorbis
    libsamplerate
  ];

  qtWrapperArgs = [
    "--prefix PATH ':' ${lib.makeBinPath [
      cdrdao
      cdrtools
      dvdplusrwtools
      libburn
      normalize
      sox
      transcode
      vcdimager
      flac
    ]}"
  ];
  meta.mainProgram = "k3b";
}
