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

  postFixup = ''
    patchelf $out/lib/libk3blib.so --add-rpath "${lib.makeLibraryPath [ cdparanoia libdvdcss ]}"
  '';

  meta.mainProgram = "k3b";
}
