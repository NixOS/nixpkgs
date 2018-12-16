{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, boost, python3Packages
, gtest
, darwin
, systemd

# database plugins
, clientSupport ? true, mpd_clientlib

# storage plugins

# input plugins
, curlSupport ? true, curl
, mmsSupport ? true, glib, libmms
, nfsSupport ? true, libnfs
, smbSupport ? true, samba

# commercial services
, soundcloudSupport ? true

# archive plugins
, bzip2Support ? true, bzip2
, zipSupport ? true, zziplib

# tag plugins
, id3tagSupport ? true, libid3tag

# decoder plugins
, audiofileSupport ? true, audiofile
, aacSupport ? true, faad2
, ffmpegSupport ? true, ffmpeg
, flacSupport ? true, flac
, fluidsynthSupport ? true, fluidsynth
, gmeSupport ? true, game-music-emu
, madSupport ? true, libmad
, mikmodSupport ? true, libmikmod
, mpg123Support ? true, mpg123
, opusSupport ? true, libopus, libogg
, vorbisSupport ? true, libvorbis

# encoder plugins
, vorbisencSupport ? true
, lameSupport ? true, lame

# filter plugins
, samplerateSupport ? true, libsamplerate

# output plugins
, alsaSupport ? true, alsaLib
, aoSupport ? true, libao
, jackSupport ? true, libjack2
, ossSupport ? true
, pulseaudioSupport ? true, libpulseaudio
, shoutSupport ? true, libshout

# misc libraries
, dbusSupport ? true, dbus
, icuSupport ? true, icu
, iconvSupport ? true
, pcreSupport ? true, pcre
, sqliteSupport ? true, sqlite
, yajlSupport ? true, yajl

# this should be zeroconf support
, avahiSupport ? true, avahi
}:


assert soundcloudSupport -> curlSupport == true;
assert soundcloudSupport -> yajlSupport == true;

assert vorbisencSupport -> vorbisSupport == true;

let
  inherit (stdenv.lib) optional optionals optionalString;
  flag = c: f: if c
    then "-D${f}=true"
    else "-D${f}=false";
  feature = c: f: if c
    then "-D${f}=enabled"
    else "-D${f}=disabled";
  major = "0.21";
  minor = "3";
in stdenv.mkDerivation rec {
  pname = "mpd";
  version = "${major}${if minor == "" then "" else "." + minor}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "MPD";
    rev    = "v${version}";
    sha256 = "06qrx87misfx21mvwlfz4hd51rzlw9vmnvggal4v5k95d7yw5llf";
  };

  doCheck = true;

  buildInputs = [
    boost
  ] ++ optionals stdenv.isLinux [
    systemd
  ] ++ optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudioKit
  ]
    # database plugins
    ++ optional clientSupport mpd_clientlib
    # storage plugins
    # input plugins
    ++ optional curlSupport curl
    ++ optionals mmsSupport [ glib libmms ]
    ++ optional (!stdenv.isDarwin && nfsSupport) libnfs
    ++ optional (!stdenv.isDarwin && smbSupport) samba
    # commercial services
    # archive plugins
    ++ optional bzip2Support bzip2
    ++ optional zipSupport zziplib
    # tag plugins
    ++ optional id3tagSupport libid3tag
    # decoder plugins
    ++ optional audiofileSupport audiofile
    ++ optional aacSupport faad2
    ++ optional ffmpegSupport ffmpeg
    ++ optional flacSupport flac
    ++ optional fluidsynthSupport fluidsynth
    ++ optional gmeSupport game-music-emu
    # using libmad to decode mp3 files on darwin is causing a segfault -- there
    # is probably a solution, but I'm disabling it for now
    ++ optional (!stdenv.isDarwin && madSupport) libmad
    ++ optional mikmodSupport libmikmod
    ++ optional mpg123Support mpg123
    ++ optionals opusSupport [ libopus libogg ]
    ++ optional vorbisSupport libvorbis
    # encoder plugins
    ++ optional lameSupport lame
    # filter plugins
    ++ optional samplerateSupport libsamplerate
    # output plugins
    ++ optional (stdenv.isLinux && alsaSupport) alsaLib
    ++ optional aoSupport libao
    ++ optional (!stdenv.isDarwin && jackSupport) libjack2
    ++ optional (!stdenv.isDarwin && pulseaudioSupport) libpulseaudio
    ++ optional shoutSupport libshout
    # misc libraries
    ++ optional dbusSupport dbus
    ++ optional icuSupport icu
    ++ optional pcreSupport pcre
    ++ optional sqliteSupport sqlite
    ++ optional yajlSupport yajl

    ++ optional avahiSupport avahi
  ;

  checkInputs = [
    gtest
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig python3Packages.sphinx
  ];

  mesonFlags = [
    (flag true "documentation")
    (flag true "test")
    (feature true "ipv6")
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    (feature true "systemd")
    "-Dsystemd_system_unit_dir=${placeholder "out"}/etc/systemd/system"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/etc/systemd/user"
  ] ++ [
    # database plugins
    (feature clientSupport "libmpdclient")
    # storage plugins
    # input plugins
    (feature curlSupport "curl")
    (feature mmsSupport "mms")
    (feature (!stdenv.isDarwin && nfsSupport) "nfs")
    (feature (!stdenv.isDarwin && smbSupport) "smbclient")
    # commercial services
    (feature soundcloudSupport "soundcloud")
    # archive plugins
    (feature bzip2Support "bzip2")
    (feature zipSupport "zzip")
    # tag plugins
    (feature id3tagSupport "id3tag")
    # decoder plugins
    (feature audiofileSupport "audiofile")
    (feature aacSupport "faad")
    (feature ffmpegSupport "ffmpeg")
    (feature flacSupport "flac")
    (feature fluidsynthSupport "fluidsynth")
    (feature gmeSupport "gme")
    (feature (!stdenv.isDarwin && madSupport) "mad")
    (feature mikmodSupport "mikmod")
    (feature mpg123Support "mpg123")
    (feature opusSupport "opus")
    (feature vorbisSupport "vorbis")
    # encoder plugins
    (feature vorbisencSupport "vorbisenc")
    (feature lameSupport "lame")
    # filter plugins
    (feature samplerateSupport "libsamplerate")
    # output plugins
    (feature (stdenv.isLinux && alsaSupport) "alsa")
    (feature aoSupport "ao")
    (feature (!stdenv.isDarwin && jackSupport) "jack")
    (feature ossSupport "oss")
    (feature (!stdenv.isDarwin && pulseaudioSupport) "pulse")
    (feature shoutSupport "shout")
    # misc libraries
    (feature dbusSupport "dbus")
    (feature icuSupport "icu")
    (feature iconvSupport "iconv")
    (feature pcreSupport "pcre")
    (feature sqliteSupport "sqlite")
    (feature yajlSupport "yajl")
    (optionalString avahiSupport "-Dzeroconf=avahi")
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
