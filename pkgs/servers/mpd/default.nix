{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, systemd, boost, darwin
# Inputs
, curl, libmms, libnfs, samba
# Archive support
, bzip2, zziplib
# Codecs
, audiofile, faad2, ffmpeg, flac, fluidsynth, game-music-emu
, libmad, libmikmod, mpg123, libopus, libvorbis, lame
# Filters
, libsamplerate
# Outputs
, alsaLib, libjack2, libpulseaudio, libshout
# Misc
, icu, sqlite, avahi, dbus, pcre, libgcrypt, expat
# Services
, yajl
# Client support
, mpd_clientlib
# Tag support
, libid3tag
}:

let
  major = "0.21";
  minor = "9";

  lib = stdenv.lib;
  mkDisable = f: "-D${f}=disabled";
  mkEnable = f: "-D${f}=enabled";
  keys = lib.mapAttrsToList (k: v: k);

  featureDependencies = {
    # Storage plugins
    udisks        = [ dbus ];
    webdav        = [ curl expat ];
    # Input plugins
    curl          = [ curl ];
    mms           = [ libmms ];
    nfs           = [ libnfs ];
    smbclient     = [ samba ];
    # Archive support
    bzip2         = [ bzip2 ];
    zzip          = [ zziplib ];
    # Decoder plugins
    audiofile     = [ audiofile ];
    faad          = [ faad2 ];
    ffmpeg        = [ ffmpeg ];
    flac          = [ flac ];
    fluidsynth    = [ fluidsynth ];
    gme           = [ game-music-emu ];
    mad           = [ libmad ];
    mikmod        = [ libmikmod ];
    mpg123        = [ mpg123 ];
    opus          = [ libopus ];
    vorbis        = [ libvorbis ];
    # Encoder plugins
    vorbisenc     = [ libvorbis ];
    lame          = [ lame ];
    # Filter plugins
    libsamplerate = [ libsamplerate ];
    # Output plugins
    alsa          = [ alsaLib ];
    jack          = [ libjack2 ];
    pulse         = [ libpulseaudio ];
    shout         = [ libshout ];
    # Commercial services
    qobuz         = [ curl libgcrypt yajl ];
    soundcloud    = [ curl yajl ];
    tidal         = [ curl yajl ];
    # Client support
    libmpdclient  = [ mpd_clientlib ];
    # Tag support
    id3tag        = [ libid3tag ];
    # Misc
    dbus          = [ dbus ];
    expat         = [ expat ];
    icu           = [ icu ];
    pcre          = [ pcre ];
    sqlite        = [ sqlite ];
    systemd       = [ systemd ];
    yajl          = [ yajl ];
    zeroconf      = [ avahi dbus ];
  };

  run = { features ? null }:
    let
      fl = if (features == null )
        then keys featureDependencies
        else features;

      # Disable platform specific features if needed
      # using libmad to decode mp3 files on darwin is causing a segfault -- there
      # is probably a solution, but I'm disabling it for now
      platformMask = lib.optionals stdenv.isDarwin [ "mad" "pulse" "jack" "nfs" "smb" ]
                  ++ lib.optionals (!stdenv.isLinux) [ "alsa" "systemd" ];
      features_ = lib.subtractLists platformMask fl;

    in stdenv.mkDerivation rec {
      pname = "mpd";
      version = "${major}${if minor == "" then "" else "." + minor}";

      src = fetchFromGitHub {
        owner  = "MusicPlayerDaemon";
        repo   = "MPD";
        rev    = "v${version}";
        sha256 = "1qiigs62pima7pxb6fa7jm0xbgvb7897v89qcl8y2g3gm7sim7g2";
      };

      buildInputs = [ glib boost ]
        ++ (lib.concatLists (lib.attrVals features_ featureDependencies))
        ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.AudioToolbox;

      nativeBuildInputs = [ meson ninja pkgconfig ];

      enableParallelBuilding = true;

      mesonFlags =
        map mkEnable features_ ++ map mkDisable (lib.subtractLists features_ (keys featureDependencies))
        ++ lib.optional (lib.any (x: x == "zeroconf") features_)
          "-Dzeroconf=avahi"
        ++ lib.optional stdenv.isLinux
          "-Dsystemd_system_unit_dir=etc/systemd/system";

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
    };
in
{
  mpd = run { };
  mpd-small = run { features = [
    "webdav" "curl" "mms" "nfs" "bzip2" "zzip"
    "audiofile" "faad" "flac" "gme" "mad"
    "mpg123" "opus" "vorbis"
    "vorbisenc" "lame" "libsamplerate"
    "alsa" "shout" "libmpdclient"
    "id3tag" "expat" "pcre" "yajl" "sqlite"
    "soundcloud" "qobuz" "tidal"
    "systemd"
  ]; };
}
