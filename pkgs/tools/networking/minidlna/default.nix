{ stdenv, fetchurl, ffmpeg, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite, gettext }:

let version = "1.1.5"; in

stdenv.mkDerivation {
  name = "minidlna-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/minidlna/minidlna/${version}/minidlna-${version}.tar.gz";
    sha256 = "16xb2nz8g1dwcail1zmpj8s426pygz0fdpd6ip6zaamv2q2asxw4";
  };

  preConfigure = ''
    export makeFlags="INSTALLPREFIX=$out"
  '';

  buildInputs = [ ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite gettext ];

  postInstall = ''
    mkdir -p $out/share/man/man{5,8}
    cp minidlna.conf.5 $out/share/man/man5
    cp minidlnad.8 $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "Media server software";
    longDescription = ''
      MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully
      compliant with DLNA/UPnP-AV clients.
    '';
    homepage = http://sourceforge.net/projects/minidlna/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
