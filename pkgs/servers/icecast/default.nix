{stdenv, fetchurl
, libxml2, libxslt, curl
, libvorbis, libtheora, speex, libkate }:

stdenv.mkDerivation rec {
  name = "icecast-2.3.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/icecast/${name}.tar.gz";
    sha256 = "0vf38mk13z1czpbj0g8va4rzjf201slqmiwcs8y9i6iwz3shc78v";
  };

  buildInputs = [ libxml2 libxslt curl libvorbis libtheora speex libkate ];

  meta = {
    description = "Server software for streaming multimedia";

    longDescription = ''
      Icecast is a streaming media server which currently supports Ogg Vorbis and MP3
      audio streams. It can be used to create an Internet radio station or a
      privately running jukebox and many things in between. It is very versatile in
      that new formats can be added relatively easily and supports open standards for
      commuincation and interaction.
    '';
  

    homepage = http://www.icecast.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}

