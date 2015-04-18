{ stdenv, fetchurl, pkgconfig, glib, systemd, boost
, alsaSupport, alsaLib
, flacSupport, flac
, vorbisSupport, libvorbis
, madSupport, libmad
, id3tagSupport, libid3tag
, mikmodSupport, libmikmod
, shoutSupport, libshout
, sqliteSupport, sqlite
, curlSupport, curl
, audiofileSupport, audiofile
, bzip2Support, bzip2
, ffmpegSupport, ffmpeg
, fluidsynthSupport, fluidsynth
, zipSupport, zziplib
, samplerateSupport, libsamplerate
, mmsSupport, libmms
, mpg123Support, mpg123
, aacSupport, faad2
, pulseaudioSupport, pulseaudio
, jackSupport, jack2
, gmeSupport, game-music-emu
, icuSupport, icu
, clientSupport, mpd_clientlib
, opusSupport, libopus
}:

let
  opt = stdenv.lib.optional;
  mkFlag = c: f: if c then "--enable-${f}" else "--disable-${f}";
  major = "0.19";
  minor = "9";

in stdenv.mkDerivation rec {
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
      (mkFlag pulseaudioSupport "pulse")
      (mkFlag jackSupport "jack")
      (mkFlag stdenv.isDarwin "osx")
      (mkFlag icuSupport "icu")
      (mkFlag gmeSupport "gme")
      (mkFlag clientSupport "libmpdclient")
      (mkFlag opusSupport "opus")
      "--enable-debug"
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
    maintainers = with maintainers; [ astsmtl fuuzetsu emery ];
    platforms   = platforms.unix;

    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
  };
}
