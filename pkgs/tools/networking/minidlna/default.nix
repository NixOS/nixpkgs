{stdenv, fetchurl, libav, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite }:
stdenv.mkDerivation rec {
  name = "minidlna-1.0.24";
  src = fetchurl {
    url = mirror://sourceforge/project/minidlna/minidlna/1.0.24/minidlna_1.0.24_src.tar.gz;
    sha256 = "0hmrrrq7d8940rckwj93bcdpdxxy3qfkjl17j5k31mi37hqc42l4";
  };

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libav}/include/libavutil -I${libav}/include/libavcodec -I${libav}/include/libavformat"
    export makeFlags="INSTALLPREFIX=$out"
  '';

  buildInputs = [ libav flac libvorbis libogg libid3tag libexif libjpeg sqlite ];
  patches = [ ./config.patch ];

  meta = {
    description = "MiniDLNA Media Server";
    longDescription = ''
      MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully 
      compliant with DLNA/UPnP-AV clients. 
    '';
    homepage = http://sourceforge.net/projects/minidlna/;
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.all;
  };
}
