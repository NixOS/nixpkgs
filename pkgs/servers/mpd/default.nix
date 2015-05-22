{ stdenv, fetchurl, pkgconfig, glib, systemd, boost
, alsaSupport ? true, alsaLib
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
, pulseaudioSupport ? true, pulseaudio
, jackSupport ? true, jack2
, gmeSupport ? true, game-music-emu
, icuSupport ? true, icu
, clientSupport ? false, mpd_clientlib
, opusSupport ? true, libopus
}:

with stdenv.lib;
let
  opt = optional;
  major = "0.19";
  minor = "9";
in
stdenv.mkDerivation rec {
  name = "mpd-${major}.${minor}";
  src = fetchurl {
    url    = "http://www.musicpd.org/download/mpd/${major}/${name}.tar.xz";
    sha256 = "0vzj365s4j0pw5w37lfhx3dmpkdp85driravsvx8rlrw0lii91a7";
  };

  buildInputs = [ pkgconfig glib boost ]
    ++ opt stdenv.isLinux systemd
    ++ opt (stdenv.isLinux && alsaSupport) alsaLib
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
    ++ opt pulseaudioSupport pulseaudio
    ++ opt jackSupport jack2
    ++ opt gmeSupport game-music-emu
    ++ opt icuSupport icu
    ++ opt clientSupport mpd_clientlib
    ++ opt opusSupport libopus;

  configureFlags =
    [ (mkEnable (!stdenv.isDarwin && alsaSupport) "alsa" null)
      (mkEnable flacSupport "flac" null)
      (mkEnable vorbisSupport "vorbis" null)
      (mkEnable vorbisSupport "vorbis-encoder" null)
      (mkEnable (!stdenv.isDarwin && madSupport) "mad" null)
      (mkEnable mikmodSupport "mikmod" null)
      (mkEnable id3tagSupport "id3" null)
      (mkEnable shoutSupport "shout" null)
      (mkEnable sqliteSupport "sqlite" null)
      (mkEnable curlSupport "curl" null)
      (mkEnable audiofileSupport "audiofile" null)
      (mkEnable bzip2Support "bzip2" null)
      (mkEnable ffmpegSupport "ffmpeg" null)
      (mkEnable fluidsynthSupport "fluidsynth" null)
      (mkEnable zipSupport "zzip" null)
      (mkEnable samplerateSupport "lsr" null)
      (mkEnable mmsSupport "mms" null)
      (mkEnable mpg123Support "mpg123" null)
      (mkEnable aacSupport "aac" null)
      (mkEnable pulseaudioSupport "pulse" null)
      (mkEnable jackSupport "jack" null)
      (mkEnable stdenv.isDarwin "osx" null)
      (mkEnable icuSupport "icu" null)
      (mkEnable gmeSupport "gme" null)
      (mkEnable clientSupport "libmpdclient" null)
      (mkEnable opusSupport "opus" null)
      (mkEnable true "debug" null)
    ]
    ++ opt stdenv.isLinux
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system";

  NIX_LDFLAGS = ''
    ${if shoutSupport then "-lshout" else ""}
  '';

  meta = {
    description = "A flexible, powerful daemon for playing music";
    homepage    = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl fuuzetsu emery ];
    platforms   = platforms.unix;

    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
  };
}
