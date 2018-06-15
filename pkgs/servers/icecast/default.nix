{stdenv, fetchurl
, libxml2, libxslt, curl
, libvorbis, libtheora, speex, libkate, libopus }:

stdenv.mkDerivation rec {
  name = "icecast-2.4.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/icecast/${name}.tar.gz";
    sha256 = "14n5vm2xnyn8y7kl46lnnlgv6v5fjykhc57ffdsh0qaxfs6a8p68";
  };

  buildInputs = [ libxml2 libxslt curl libvorbis libtheora speex libkate libopus ];

  hardeningEnable = [ "pie" ];

  meta = {
    description = "Server software for streaming multimedia";

    longDescription = ''
      Icecast is a streaming media server which currently supports
      Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams.
      It can be used to create an Internet radio station or a privately
      running jukebox and many things in between. It is very versatile
      in that new formats can be added relatively easily and supports
      open standards for commuincation and interaction.
    '';

    homepage = http://www.icecast.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
    platforms = with stdenv.lib.platforms; unix;
  };
}

