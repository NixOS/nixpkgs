{ stdenv, fetchurl, ffmpeg, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite, gettext }:

let version = "1.1.4"; in

stdenv.mkDerivation rec {
  name = "minidlna-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/minidlna/minidlna/${version}/minidlna-${version}.tar.gz";
    sha256 = "9814c04a2c506a0dd942c4218d30c07dedf90dabffbdef2d308a3f9f23545314";
  };

  preConfigure = ''
    export makeFlags="INSTALLPREFIX=$out"
  '';

  buildInputs = [ ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite gettext ];

  meta = {
    description = "Media server software";
    longDescription = ''
      MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully
      compliant with DLNA/UPnP-AV clients.
    '';
    homepage = http://sourceforge.net/projects/minidlna/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
