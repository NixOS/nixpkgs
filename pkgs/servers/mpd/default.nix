{ stdenv, fetchurl, pkgconfig, glib, systemd
, alsaSupport ? true, alsaLib
, flacSupport ? true, flac
, vorbisSupport ? true, libvorbis
, madSupport ? true, libmad
, id3tagSupport ? true, libid3tag
, mikmodSupport ? true, libmikmod
, shoutSupport ? true, libshout
, sqliteSupport ? true, sqlite
, curlSupport ? true, curl
, soupSupport ? true, libsoup
, audiofileSupport ? true, audiofile
, bzip2Support ? true, bzip2
, ffadoSupport ? true, ffado
, ffmpegSupport ? true, ffmpeg
, fluidsynthSupport ? true, fluidsynth
, zipSupport ? true, zziplib
, samplerateSupport ? true, libsamplerate
, mmsSupport ? true, libmms
, mpg123Support ? true, mpg123
, aacSupport ? true, faad2
}:

let

  opt = stdenv.lib.optional;

  mkFlag = c: f: if c then "--enable-${f}" else "--disable-${f}";

in stdenv.mkDerivation rec {
  name = "mpd-0.17.3";
  src = fetchurl {
    url = "mirror://sourceforge/musicpd/${name}.tar.bz2";
    sha256 = "1iilimlyhw22lpbqiab4qprznxg9c4d68fkrr9jww765b4c7x1ip";
  };

  buildInputs = [ pkgconfig glib systemd ]
    ++ opt alsaSupport alsaLib
    ++ opt flacSupport flac
    ++ opt vorbisSupport libvorbis
    ++ opt madSupport libmad
    ++ opt id3tagSupport libid3tag
    ++ opt mikmodSupport libmikmod
    ++ opt shoutSupport libshout
    ++ opt sqliteSupport sqlite
    ++ opt curlSupport curl
    ++ opt soupSupport libsoup
    ++ opt bzip2Support bzip2
    ++ opt audiofileSupport audiofile
    ++ opt ffadoSupport ffado
    ++ opt ffmpegSupport ffmpeg
    ++ opt fluidsynthSupport fluidsynth
    ++ opt samplerateSupport libsamplerate
    ++ opt mmsSupport libmms
    ++ opt mpg123Support mpg123
    ++ opt aacSupport faad2
    ++ opt zipSupport zziplib;

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    (mkFlag alsaSupport "alsa")
    (mkFlag flacSupport "flac")
    (mkFlag vorbisSupport "vorbis")
    (mkFlag vorbisSupport "vorbis-encoder")
    (mkFlag madSupport "mad")
    (mkFlag mikmodSupport "mikmod")
    (mkFlag id3tagSupport "id3")
    (mkFlag shoutSupport "shout")
    (mkFlag sqliteSupport "sqlite")
    (mkFlag curlSupport "curl")
    (mkFlag soupSupport "soup")
    (mkFlag audiofileSupport "audiofile")
    (mkFlag bzip2Support "bzip2")
    (mkFlag ffadoSupport "ffado")
    (mkFlag ffmpegSupport "ffmpeg")
    (mkFlag fluidsynthSupport "fluidsynth")
    (mkFlag zipSupport "zzip")
    (mkFlag samplerateSupport "lsr")
    (mkFlag mmsSupport "mms")
    (mkFlag mpg123Support "mpg123")
    (mkFlag aacSupport "aac")
  ];

  NIX_LDFLAGS = ''
    ${if shoutSupport then "-lshout" else ""}
  '';

  meta = {
    description = "A flexible, powerful daemon for playing music";
    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
    homepage = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
