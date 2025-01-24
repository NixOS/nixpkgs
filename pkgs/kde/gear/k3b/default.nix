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
  cdparanoia,
  dvdplusrwtools,
  libburn,
  libdvdcss,
  normalize,
  sox,
  transcode,
  vcdimager,
}:
mkKdeDerivation {
  pname = "k3b";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

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
    "--prefix PATH : ${
      lib.makeBinPath [
        cdrdao
        cdrtools
        dvdplusrwtools
        libburn
        normalize
        sox
        transcode
        vcdimager
        flac
      ]
    }"

    # FIXME: this should really be done with patchelf --add-rpath, but it breaks the binary somehow
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        cdparanoia
        libdvdcss
      ]
    }"
  ];

  meta.mainProgram = "k3b";
}
