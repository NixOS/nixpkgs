{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, boost, python3Packages
, gtest
, darwin
, systemd

# database plugins
, upnpSupport ? false, libupnp ? null
, clientSupport ? true, mpd_clientlib

# storage plugins
, udisksSupport ? false, udisks2 ? null
, webdavSupport ? false

# input plugins
, cdioParanoiaSupport ? false, libcdio ? null, libcdio-paranoia ? null
, curlSupport ? true, curl
, mmsSupport ? true, glib, libmms
, nfsSupport ? true, libnfs
, smbSupport ? true, samba

# commercial services
, soundcloudSupport ? true
, qobuzSupport ? false, libgcrypt ? null
, tidalSupport ? false

# archive plugins
, bzip2Support ? true, bzip2
, iso9660Support ? false
, zipSupport ? true, zziplib

# tag plugins
, id3tagSupport ? true, libid3tag
, chromaprintSupport ? false, chromaprint ? null

# decoder plugins
# , adplugSupport ? false
, audiofileSupport ? true, audiofile
, aacSupport ? true, faad2
, ffmpegSupport ? true, ffmpeg
, flacSupport ? true, flac
, fluidsynthSupport ? true, fluidsynth
, gmeSupport ? true, game-music-emu
, madSupport ? true, libmad
, mikmodSupport ? true, libmikmod
, modplugSupport ? false, libmodplug ? null
, mpcdecSupport ? false, libmpcdec ? null
, mpg123Support ? true, mpg123
, opusSupport ? true, libopus, libogg
, sidplaySupport ? false, libsidplayfp ? null
, sndfileSupport ? false, libsndfile ? null
, vorbisSupport ? true, libvorbis
, wavpackSupport ? false, wavpack ? null
, wildmidiSupport ? false, wildmidi ? null

# encoder plugins
, vorbisencSupport ? true
, lameSupport ? true, lame
, twolameSupport ? false, twolame ? null
# , shineSupport ? false

# filter plugins
, samplerateSupport ? true, libsamplerate
, soxrSupport ? false, soxr ? null

# output plugins
, alsaSupport ? true, alsaLib
, aoSupport ? true, libao
, jackSupport ? true, libjack2
, openalSupport ? false, openal ? null
, ossSupport ? true
, pulseaudioSupport ? true, libpulseaudio
, shoutSupport ? true, libshout
# , sndioSupport ? false
, solarisOutputSupport ? false

# misc libraries
, dbusSupport ? true, dbus
, expatSupport ? false, expat
, icuSupport ? true, icu
, iconvSupport ? true
, libwrapSupport ? false, tcp_wrappers ? null
, pcreSupport ? true, pcre
, sqliteSupport ? true, sqlite
, yajlSupport ? true, yajl
, zlibSupport ? false, zlib ? null

# this should be zeroconf support
, avahiSupport ? true, avahi
}:

assert upnpSupport -> libupnp != null;
assert upnpSupport -> curlSupport == true;
assert upnpSupport -> expatSupport == true;

assert udisksSupport -> udisks2 != null;
assert udisksSupport -> dbusSupport == true;

assert cdioParanoiaSupport -> libcdio != null && libcdio-paranoia != null;

assert iso9660Support -> libcdio != null;

assert chromaprintSupport -> chromaprint != null;

assert modplugSupport -> libmodplug != null;

assert mpcdecSupport -> libmpcdec != null;

assert sidplaySupport -> libsidplayfp  != null;

assert sndfileSupport -> libsndfile != null;

assert wavpackSupport -> wavpack != null;

assert wildmidiSupport -> wildmidi != null;

assert twolameSupport -> twolame != null;

assert soxrSupport -> soxr != null;

assert openalSupport -> openal != null;

assert webdavSupport -> curlSupport == true;
assert webdavSupport -> expatSupport == true;

assert libwrapSupport -> tcp_wrappers != null;

assert zlibSupport -> zlib != null;

assert soundcloudSupport -> curlSupport == true;
assert soundcloudSupport -> yajlSupport == true;

assert qobuzSupport -> libgcrypt != null;

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
    ++ optional upnpSupport libupnp
    ++ optional clientSupport mpd_clientlib
    # storage plugins
    ++ optional udisksSupport udisks2
    # input plugins
    ++ optionals cdioParanoiaSupport [ libcdio libcdio-paranoia ]
    ++ optional curlSupport curl
    ++ optionals mmsSupport [ glib libmms ]
    ++ optional (!stdenv.isDarwin && nfsSupport) libnfs
    ++ optional (!stdenv.isDarwin && smbSupport) samba
    # commercial services
    ++ optional qobuzSupport libgcrypt
    # archive plugins
    ++ optional bzip2Support bzip2
    ++ optional iso9660Support libcdio
    ++ optional zipSupport zziplib
    # tag plugins
    ++ optional id3tagSupport libid3tag
    ++ optional chromaprintSupport chromaprint
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
    ++ optional modplugSupport libmodplug
    ++ optional mpcdecSupport libmpcdec
    ++ optional mpg123Support mpg123
    ++ optionals opusSupport [ libopus libogg ]
    ++ optional sidplaySupport libsidplayfp
    ++ optional sndfileSupport libsndfile
    ++ optional vorbisSupport libvorbis
    ++ optional wavpackSupport wavpack
    ++ optional wildmidiSupport wildmidi
    # encoder plugins
    ++ optional lameSupport lame
    ++ optional twolameSupport twolame
    # filter plugins
    ++ optional samplerateSupport libsamplerate
    ++ optional soxrSupport soxr
    # output plugins
    ++ optional (stdenv.isLinux && alsaSupport) alsaLib
    ++ optional aoSupport libao
    ++ optional (!stdenv.isDarwin && jackSupport) libjack2
    ++ optional openalSupport openal
    ++ optional (!stdenv.isDarwin && pulseaudioSupport) libpulseaudio
    ++ optional shoutSupport libshout
    # misc libraries
    ++ optional dbusSupport dbus
    ++ optional expatSupport expat
    ++ optional icuSupport icu
    ++ optional libwrapSupport tcp_wrappers
    ++ optional pcreSupport pcre
    ++ optional sqliteSupport sqlite
    ++ optional yajlSupport yajl
    ++ optional zlibSupport zlib

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
    (feature upnpSupport "upnp")
    (feature clientSupport "libmpdclient")
    # storage plugins
    (feature udisksSupport "udisks")
    (feature webdavSupport "webdav")
    # input plugins
    (feature cdioParanoiaSupport "cdio_paranoia")
    (feature curlSupport "curl")
    (feature mmsSupport "mms")
    (feature (!stdenv.isDarwin && nfsSupport) "nfs")
    (feature (!stdenv.isDarwin && smbSupport) "smbclient")
    # commercial services
    (feature soundcloudSupport "soundcloud")
    (feature qobuzSupport "qobuz")
    (feature tidalSupport "tidal")
    # archive plugins
    (feature bzip2Support "bzip2")
    (feature iso9660Support "iso9660")
    (feature zipSupport "zzip")
    # tag plugins
    (feature id3tagSupport "id3tag")
    (feature chromaprintSupport "chromaprint")
    # decoder plugins
    # (feature adplugSupport "adplug")
    (feature audiofileSupport "audiofile")
    (feature aacSupport "faad")
    (feature ffmpegSupport "ffmpeg")
    (feature flacSupport "flac")
    (feature fluidsynthSupport "fluidsynth")
    (feature gmeSupport "gme")
    (feature (!stdenv.isDarwin && madSupport) "mad")
    (feature mikmodSupport "mikmod")
    (feature modplugSupport "modplug")
    (feature mpcdecSupport "mpcdec")
    (feature mpg123Support "mpg123")
    (feature opusSupport "opus")
    (feature sidplaySupport "sidplay")
    (feature sndfileSupport "sndfile")
    (feature vorbisSupport "vorbis")
    (feature wavpackSupport "wavpack")
    (feature wildmidiSupport "wildmidi")
    # encoder plugins
    (feature vorbisencSupport "vorbisenc")
    (feature lameSupport "lame")
    (feature twolameSupport "twolame")
    # filter plugins
    (feature samplerateSupport "libsamplerate")
    (feature soxrSupport "soxr")
    # output plugins
    (feature (stdenv.isLinux && alsaSupport) "alsa")
    (feature aoSupport "ao")
    (feature (!stdenv.isDarwin && jackSupport) "jack")
    (feature openalSupport "openal")
    (feature ossSupport "oss")
    (feature (!stdenv.isDarwin && pulseaudioSupport) "pulse")
    (feature shoutSupport "shout")
    # (feature sndioSupport "sndio")
    (feature solarisOutputSupport "solaris_output")
    # misc libraries
    (feature dbusSupport "dbus")
    (feature expatSupport "expat")
    (feature icuSupport "icu")
    (feature iconvSupport "iconv")
    (feature libwrapSupport "libwrap")
    (feature pcreSupport "pcre")
    (feature sqliteSupport "sqlite")
    (feature yajlSupport "yajl")
    (feature zlibSupport "zlib")
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
