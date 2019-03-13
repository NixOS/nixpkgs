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
, icu, sqlite, avahi, dbus
# Services
, yajl
# Client support
, mpd_clientlib
# Tag support
, libid3tag
#, features ? []
}:

let
  major = "0.21";
  minor = "5";

  lib = stdenv.lib;
  mkDisable = f: "-D${f}=disabled";
  mkEnable = f: "-D${f}=enabled";
  keys = lib.mapAttrsToList (k: v: k);

  featureDependencies = {
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
    # Misc
    icu           = [ icu ];
    sqlite        = [ sqlite ];
    zeroconf      = [ avahi dbus ];
    # Commercial services
    soundcloud    = [ curl yajl ];
    # Client support
    libmpdclient  = [ mpd_clientlib ];
    # Tag support
    id3tag        = [ libid3tag ];
    # Misc
    systemd       = [ systemd ];
    yajl          = [ yajl ];
  };

  features = keys featureDependencies;

  # Disable platform specific features if needed
  # using libmad to decode mp3 files on darwin is causing a segfault -- there
  # is probably a solution, but I'm disabling it for now
  platformMask = lib.optionals stdenv.isDarwin [ "mad" "pulse" "jack" "nfs" "smb" ]
              ++ lib.optionals (!stdenv.isLinux) [ "alsa" ];
  features_ = lib.subtractLists platformMask features;

in stdenv.mkDerivation rec {
  pname = "mpd";
  version = "${major}${if minor == "" then "" else "." + minor}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "MPD";
    rev    = "v${version}";
    sha256 = "0bdnng34hwmwy5hll6ks3yksw3l77w9vaip2l6wkilqhzyibkbpl";
  };

  buildInputs = [ glib boost ]
    ++ (lib.concatLists (lib.attrVals features_ featureDependencies))
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreAudioKit
    ++ lib.optional stdenv.isLinux systemd;

  nativeBuildInputs = [ meson ninja pkgconfig ];

  enableParallelBuilding = true;

  mesonFlags =
    map mkEnable features_ ++ map mkDisable (lib.subtractLists features_ (keys featureDependencies))
    ++ lib.optional (lib.any (x: x == "zeroconf") features_)
      "-Dzeroconf=avahi"
    ++ lib.optional stdenv.isLinux
      "-Dsystemd_system_unit_dir=$(out)/etc/systemd/system";

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
