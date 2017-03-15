{ stdenv, fetchurl, pkgconfig, glib, systemd, boost, darwin
, alsaSupport ? true, alsaLib
, avahiSupport ? true, avahi, dbus
, flacSupport ? true, flac
, vorbisSupport ? true, libvorbis
, madSupport ? true, libmad
, id3tagSupport ? true, libid3tag
, mikmodSupport ? true, libmikmod
, shoutSupport ? true, libshout
, sqliteSupport ? true, sqlite
, curlSupport ? true, curl
, audiofileSupport ? true, audiofile
, bzip2Support ? true, bzip2
, ffmpegSupport ? true, ffmpeg
, fluidsynthSupport ? true, fluidsynth
, zipSupport ? true, zziplib
, samplerateSupport ? true, libsamplerate
, mmsSupport ? true, libmms
, mpg123Support ? true, mpg123
, aacSupport ? true, faad2
, pulseaudioSupport ? true, libpulseaudio
, jackSupport ? true, libjack2
, gmeSupport ? true, game-music-emu
, icuSupport ? true, icu
, clientSupport ? true, mpd_clientlib
, opusSupport ? true, libopus
, soundcloudSupport ? true, yajl
}:

assert avahiSupport -> avahi != null && dbus != null;

let
  opt = stdenv.lib.optional;
  mkFlag = c: f: if c then "--enable-${f}" else "--disable-${f}";
  major = "0.20";
  minor = "6";

in stdenv.mkDerivation rec {
  name = "mpd-${major}${if minor == "" then "" else "." + minor}";
  src = fetchurl {
    url    = "http://www.musicpd.org/download/mpd/${major}/${name}.tar.xz";
    sha256 = "0isbpa79m7zf09w3s1ry638cw96rxasy1ch66zl01k75i48mw1gl";
  };

  buildInputs = [ pkgconfig glib boost ]
    ++ opt stdenv.isDarwin darwin.apple_sdk.frameworks.CoreAudioKit
    ++ opt stdenv.isLinux systemd
    ++ opt (stdenv.isLinux && alsaSupport) alsaLib
    ++ opt avahiSupport avahi
    ++ opt avahiSupport dbus
    ++ opt flacSupport flac
    ++ opt vorbisSupport libvorbis
    # using libmad to decode mp3 files on darwin is causing a segfault -- there
    # is probably a solution, but I'm disabling it for now
    ++ opt (!stdenv.isDarwin && madSupport) libmad
    ++ opt id3tagSupport libid3tag
    ++ opt mikmodSupport libmikmod
    ++ opt shoutSupport libshout
    ++ opt sqliteSupport sqlite
    ++ opt curlSupport curl
    ++ opt bzip2Support bzip2
    ++ opt audiofileSupport audiofile
    ++ opt ffmpegSupport ffmpeg
    ++ opt fluidsynthSupport fluidsynth
    ++ opt samplerateSupport libsamplerate
    ++ opt mmsSupport libmms
    ++ opt mpg123Support mpg123
    ++ opt aacSupport faad2
    ++ opt zipSupport zziplib
    ++ opt (!stdenv.isDarwin && pulseaudioSupport) libpulseaudio
    ++ opt (!stdenv.isDarwin && jackSupport) libjack2
    ++ opt gmeSupport game-music-emu
    ++ opt icuSupport icu
    ++ opt clientSupport mpd_clientlib
    ++ opt opusSupport libopus
    ++ opt soundcloudSupport yajl;

  configureFlags =
    [ (mkFlag (!stdenv.isDarwin && alsaSupport) "alsa")
      (mkFlag flacSupport "flac")
      (mkFlag vorbisSupport "vorbis")
      (mkFlag vorbisSupport "vorbis-encoder")
      (mkFlag (!stdenv.isDarwin && madSupport) "mad")
      (mkFlag mikmodSupport "mikmod")
      (mkFlag id3tagSupport "id3")
      (mkFlag shoutSupport "shout")
      (mkFlag sqliteSupport "sqlite")
      (mkFlag curlSupport "curl")
      (mkFlag audiofileSupport "audiofile")
      (mkFlag bzip2Support "bzip2")
      (mkFlag ffmpegSupport "ffmpeg")
      (mkFlag fluidsynthSupport "fluidsynth")
      (mkFlag zipSupport "zzip")
      (mkFlag samplerateSupport "lsr")
      (mkFlag mmsSupport "mms")
      (mkFlag mpg123Support "mpg123")
      (mkFlag aacSupport "aac")
      (mkFlag (!stdenv.isDarwin && pulseaudioSupport) "pulse")
      (mkFlag (!stdenv.isDarwin && jackSupport) "jack")
      (mkFlag stdenv.isDarwin "osx")
      (mkFlag icuSupport "icu")
      (mkFlag gmeSupport "gme")
      (mkFlag clientSupport "libmpdclient")
      (mkFlag opusSupport "opus")
      (mkFlag soundcloudSupport "soundcloud")
      "--enable-debug"
      "--with-zeroconf=avahi"
    ]
    ++ opt stdenv.isLinux
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system";

  NIX_LDFLAGS = ''
    ${if shoutSupport then "-lshout" else ""}
  '';

  meta = with stdenv.lib; {
    description = "A flexible, powerful daemon for playing music";
    homepage    = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl fuuzetsu ehmry fpletz ];
    platforms   = platforms.unix;

    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
  };
}
