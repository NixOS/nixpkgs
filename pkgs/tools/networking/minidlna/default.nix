{ stdenv, fetchurl, ffmpeg_3, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite, gettext }:

let version = "1.2.1"; in

stdenv.mkDerivation {
  pname = "minidlna";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/minidlna/minidlna/${version}/minidlna-${version}.tar.gz";
    sha256 = "1v1ffhmaqxpvf2vv4yyvjsks4skr9y088853awsh7ixh7ai8nf37";
  };

  preConfigure = ''
    export makeFlags="INSTALLPREFIX=$out"
  '';

  buildInputs = [ ffmpeg_3 flac libvorbis libogg libid3tag libexif libjpeg sqlite gettext ];

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
    homepage = "https://sourceforge.net/projects/minidlna/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
