{ stdenv, fetchurl, ffmpeg, flac, libvorbis, libogg, libid3tag, libexif, libjpeg, sqlite
, gettext }:

let version = "1.1.4"; in

stdenv.mkDerivation rec {
  name = "minidlna-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/minidlna/${name}.tar.gz";
    sha256 = "052kahirygwa60nyzggzmc6zkvbxq0q8s8f48bchssjh5i5c054q";
  };

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
