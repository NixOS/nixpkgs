{ stdenv, fetchFromGitHub, meson, ninja, cmake, pkgconfig, glib, systemd, boost, darwin
, libgcrypt
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
, lameSupport ? true, lame
, pulseaudioSupport ? true, libpulseaudio
, jackSupport ? true, libjack2
, gmeSupport ? true, game-music-emu
, icuSupport ? true, icu
, clientSupport ? true, mpd_clientlib
, opusSupport ? true, libopus
, yamlSupport ? false
, soundcloudSupport ? true, yajl
, nfsSupport ? true, libnfs
, smbSupport ? true, samba
, pcreSupport ? false, pcre
, sndioSupport ? false, sndio
, upnpSupport ? false, miniupnpc
, chromaprintSupport ? false, chromaprint
, soxrSupport ? false, soxr
, cdparanoiaSupport ? false, cdparanoia
, aoSupport ? false, libao
, openalSupport ? false, openal
, modplugSupport ? false, libmodplug
, mpcdecSupport ? false, libmpcdec
, sndfileSupport ? false, libsndfile
, wavpackSupport ? false, wavpack
, wildmidiSupport ? false, wildmidi
, sidplaySupport ? false, libsidplayfp
, twolameSupport ? false, twolame
}:

assert avahiSupport -> avahi != null && dbus != null;

let
  opt = stdenv.lib.optional;
  mkFlag = c: f: if c then "-D${f}=enabled" else "-D${f}=disabled";
  major = "0.21";
  minor = "16";

in stdenv.mkDerivation rec {
  pname = "mpd";
  version = "${major}${if minor == "" then "" else "." + minor}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "MPD";
    rev    = "v${version}";
    sha256 = "0yfzn1hcyww8z5pp70n7iinycz097vjc6q9fzmfrc6ikvz3db8f4";
  };

  buildInputs = [ glib boost libgcrypt ]
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
    ++ opt lameSupport lame
    ++ opt zipSupport zziplib
    ++ opt (!stdenv.isDarwin && pulseaudioSupport) libpulseaudio
    ++ opt (!stdenv.isDarwin && jackSupport) libjack2
    ++ opt gmeSupport game-music-emu
    ++ opt icuSupport icu
    ++ opt clientSupport mpd_clientlib
    ++ opt opusSupport libopus
    ++ opt (yamlSupport || soundcloudSupport) yajl
    ++ opt (!stdenv.isDarwin && nfsSupport) libnfs
    ++ opt (!stdenv.isDarwin && smbSupport) samba
    ++ opt pcreSupport pcre
    ++ opt sndioSupport sndio
    ++ opt upnpSupport miniupnpc
    ++ opt chromaprintSupport chromaprint
    ++ opt soxrSupport soxr
    ++ opt cdparanoiaSupport cdparanoia
    ++ opt aoSupport libao
    ++ opt openalSupport openal
    ++ opt modplugSupport libmodplug
    ++ opt mpcdecSupport libmpcdec
    ++ opt sndfileSupport libsndfile
    ++ opt wavpackSupport wavpack
    ++ opt wildmidiSupport wildmidi
    ++ opt sidplaySupport libsidplayfp
    ++ opt twolameSupport twolame
    ;

  nativeBuildInputs = [ meson ninja cmake pkgconfig ];

  enableParallelBuilding = true;

  mesonFlags =
    [ (mkFlag (!stdenv.isDarwin && alsaSupport) "alsa")
      (mkFlag flacSupport "flac")
      (mkFlag vorbisSupport "vorbis")
      (mkFlag vorbisSupport "vorbisenc")
      (mkFlag (!stdenv.isDarwin && madSupport) "mad")
      (mkFlag mikmodSupport "mikmod")
      (mkFlag id3tagSupport "id3tag")
      (mkFlag shoutSupport "shout")
      (mkFlag sqliteSupport "sqlite")
      (mkFlag curlSupport "curl")
      (mkFlag audiofileSupport "audiofile")
      (mkFlag bzip2Support "bzip2")
      (mkFlag ffmpegSupport "ffmpeg")
      (mkFlag fluidsynthSupport "fluidsynth")
      (mkFlag zipSupport "zzip")
      (mkFlag samplerateSupport "libsamplerate")
      (mkFlag mmsSupport "mms")
      (mkFlag mpg123Support "mpg123")
      (mkFlag aacSupport "faad")
      (mkFlag lameSupport "lame")
      (mkFlag (!stdenv.isDarwin && pulseaudioSupport) "pulse")
      (mkFlag (!stdenv.isDarwin && jackSupport) "jack")
      #(mkFlag stdenv.isDarwin "osx")
      (mkFlag icuSupport "icu")
      (mkFlag gmeSupport "gme")
      (mkFlag clientSupport "libmpdclient")
      (mkFlag opusSupport "opus")
      (mkFlag yamlSupport "yajl")
      (mkFlag soundcloudSupport "soundcloud")
      (mkFlag (!stdenv.isDarwin && nfsSupport) "nfs")
      (mkFlag (!stdenv.isDarwin && smbSupport) "smbclient")
      (mkFlag pcreSupport "pcre")
      (mkFlag sndioSupport "sndio")
      (mkFlag upnpSupport "upnp")
      (mkFlag chromaprintSupport "chromaprint")
      (mkFlag soxrSupport "soxr")
      (mkFlag cdparanoiaSupport "cdio_paranoia")
      (mkFlag aoSupport "ao")
      (mkFlag openalSupport "openal")
      (mkFlag modplugSupport "modplug")
      (mkFlag mpcdecSupport "mpcdec")
      (mkFlag sndfileSupport "sndfile")
      (mkFlag wavpackSupport "wavpack")
      (mkFlag wildmidiSupport "wildmidi")
      (mkFlag sidplaySupport "sidplay")
      (mkFlag twolameSupport "twolame")
      (mkFlag false "iso9660")
      (mkFlag false "qobuz")
      (mkFlag false "tidal")
      (mkFlag false "tremor") # conflicts with vorbis
      (mkFlag false "adplug")
      (mkFlag false "shine")
      "-Ddebug=true"
      "-Dzeroconf=avahi"
    ]
    ++ opt stdenv.isLinux
      "-Dsystemd_system_unit_dir=etc/systemd/system";

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
