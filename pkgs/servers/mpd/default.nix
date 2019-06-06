{ stdenv, lib, fetchFromGitHub, meson, ninja, pkgconfig, python3Packages
, boost17x, glib, pcre, zlib
, darwin ? null
, systemd ? null
, aacSupport ? true, faad2
, alsaSupport ? true, alsaLib
, audiofileSupport ? true, audiofile
, avahiSupport ? true, avahi, dbus
, bzip2Support ? true, bzip2
, clientSupport ? true, mpd_clientlib
, curlSupport ? true, curl
, ffmpegSupport ? true, ffmpeg
, flacSupport ? true, flac
, fluidsynthSupport ? true, fluidsynth
, gmeSupport ? true, game-music-emu
, icuSupport ? true, icu
, id3tagSupport ? true, libid3tag
, jackSupport ? true, libjack2
, lameSupport ? true, lame
, madSupport ? true, libmad
, mikmodSupport ? true, libmikmod
, mmsSupport ? true, libmms
, mpg123Support ? true, mpg123
, nfsSupport ? true, libnfs
, opusSupport ? true, libopus
, pulseaudioSupport ? true, libpulseaudio
, samplerateSupport ? true, libsamplerate
, shoutSupport ? true, libshout
, smbSupport ? true, samba
, soundcloudSupport ? true, yajl
, sqliteSupport ? true, sqlite
, vorbisSupport ? true, libvorbis
, zipSupport ? true, zziplib
}:

assert avahiSupport -> avahi != null && dbus != null;

let
  major = "0.21";
  minor = "10";
  mkFlag = c: f: "-D${f}=${if c then "enabled" else "disabled"}";

in stdenv.mkDerivation rec {
  pname = "mpd";
  version = "${major}${lib.optionalString (minor != "") "." + minor}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "MPD";
    rev    = "v${version}";
    sha256 = "1syh4qa4x7w7syh49qjz0m7gaiwnpjwkglbb21191csqh6jdk2nk";
  };

  buildInputs = [
    # boost 1.6.x is broken with mpd
    boost17x

    audiofile avahi bzip2 curl dbus faad2 ffmpeg flac fluidsynth
    game-music-emu glib icu lame libid3tag libmikmod libmms libopus
    libsamplerate libshout libvorbis mpd_clientlib mpg123 pcre sqlite
    yajl zlib zziplib

  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudioKit
  ] ++ lib.optionals stdenv.isLinux [
    alsaLib libjack2 libnfs libpulseaudio samba systemd
    # using libmad to decode mp3 files on darwin is causing a segfault
    libmad
  ];

  nativeBuildInputs = [ meson ninja pkgconfig python3Packages.sphinx ];

  mesonFlags = [
    "-Ddocumentation=true"
    "-Dzeroconf=avahi"
    (mkFlag true "pcre")
    (mkFlag true "zlib")
    (mkFlag aacSupport "faad")
    (mkFlag audiofileSupport "audiofile")
    (mkFlag bzip2Support "bzip2")
    (mkFlag clientSupport "libmpdclient")
    (mkFlag curlSupport "curl")
    (mkFlag ffmpegSupport "ffmpeg")
    (mkFlag flacSupport "flac")
    (mkFlag fluidsynthSupport "fluidsynth")
    (mkFlag gmeSupport "gme")
    (mkFlag icuSupport "icu")
    (mkFlag id3tagSupport "id3tag")
    (mkFlag lameSupport "lame")
    (mkFlag mikmodSupport "mikmod")
    (mkFlag mmsSupport "mms")
    (mkFlag mpg123Support "mpg123")
    (mkFlag opusSupport "opus")
    (mkFlag samplerateSupport "libsamplerate")
    (mkFlag shoutSupport "shout")
    (mkFlag soundcloudSupport "soundcloud")
    (mkFlag soundcloudSupport "yajl")
    (mkFlag sqliteSupport "sqlite")
    (mkFlag vorbisSupport "vorbis")
    (mkFlag vorbisSupport "vorbisenc")
    (mkFlag zipSupport "zzip")
  ] ++ lib.optionals stdenv.isLinux [
    (mkFlag true "dbus")
    (mkFlag true "systemd")
    (mkFlag alsaSupport "alsa")
    (mkFlag jackSupport "jack")
    (mkFlag madSupport "mad")
    (mkFlag nfsSupport "nfs")
    (mkFlag pulseaudioSupport "pulse")
    (mkFlag smbSupport "smbclient")
    "-Dsystemd_system_unit_dir=${placeholder "out"}/etc/systemd/system"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/etc/systemd/user"
  ];

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
