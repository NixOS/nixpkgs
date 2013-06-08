{ stdenv, fetchurl, ffmpeg, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite }:

let version = "1.0.25"; in

stdenv.mkDerivation rec {
  name = "minidlna-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/minidlna/minidlna/${version}/minidlna_${version}_src.tar.gz";
    sha256 = "0l987x3bx2apnlihnjbhywgk5b2g9ysiapwclz5vphj2w3xn018p";
  };

  patches = [ ./config.patch ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${ffmpeg}/include/libavutil -I${ffmpeg}/include/libavcodec -I${ffmpeg}/include/libavformat"
    export makeFlags="INSTALLPREFIX=$out"
  '';

  buildInputs = [ ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite ];

  meta = {
    description = "MiniDLNA Media Server";
    longDescription = ''
      MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully
      compliant with DLNA/UPnP-AV clients.
    '';
    homepage = http://sourceforge.net/projects/minidlna/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
