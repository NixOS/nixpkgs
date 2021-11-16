{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, glib, systemd, boost, fmt
# Darwin inputs
, AudioToolbox, AudioUnit
# Inputs
, curl, libmms, libnfs, liburing, samba
# Archive support
, bzip2, zziplib
# Codecs
, audiofile, faad2, ffmpeg, flac, fluidsynth, game-music-emu
, libmad, libmikmod, mpg123, libopus, libvorbis, lame
# Filters
, libsamplerate
# Outputs
, alsa-lib, libjack2, libpulseaudio, libshout, pipewire
# Misc
, icu, sqlite, avahi, dbus, pcre, libgcrypt, expat
# Services
, yajl
# Client support
, libmpdclient
# Tag support
, libid3tag
, nixosTests
# For documentation
, doxygen
, python3Packages # for sphinx-build
# For tests
, gtest
, zip
}:

let
  concatAttrVals = nameList: set: lib.concatMap (x: set.${x} or []) nameList;

  featureDependencies = {
    # Storage plugins
    udisks        = [ dbus ];
    webdav        = [ curl expat ];
    # Input plugins
    curl          = [ curl ];
    io_uring      = [ liburing ];
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
    alsa          = [ alsa-lib ];
    jack          = [ libjack2 ];
    pipewire      = [ pipewire ];
    pulse         = [ libpulseaudio ];
    shout         = [ libshout ];
    # Commercial services
    qobuz         = [ curl libgcrypt yajl ];
    soundcloud    = [ curl yajl ];
    tidal         = [ curl yajl ];
    # Client support
    libmpdclient  = [ libmpdclient ];
    # Tag support
    id3tag        = [ libid3tag ];
    # Misc
    dbus          = [ dbus ];
    expat         = [ expat ];
    icu           = [ icu ];
    pcre          = [ pcre ];
    sqlite        = [ sqlite ];
    syslog        = [ ];
    systemd       = [ systemd ];
    yajl          = [ yajl ];
    zeroconf      = [ avahi dbus ];
  };

  nativeFeatureDependencies = {
    documentation = [ doxygen python3Packages.sphinx ];
  };

  run = { features ? null }:
    let
      # Disable platform specific features if needed
      # using libmad to decode mp3 files on darwin is causing a segfault -- there
      # is probably a solution, but I'm disabling it for now
      platformMask = lib.optionals stdenv.isDarwin [ "mad" "pulse" "jack" "nfs" "smbclient" ]
                  ++ lib.optionals (!stdenv.isLinux) [ "alsa" "io_uring" "systemd" "syslog" ];

      knownFeatures = builtins.attrNames featureDependencies ++ builtins.attrNames nativeFeatureDependencies;
      platformFeatures = lib.subtractLists platformMask knownFeatures;

      features_ = if (features == null )
        then platformFeatures
        else
          let unknown = lib.subtractLists knownFeatures features; in
          if (unknown != [])
            then throw "Unknown feature(s): ${lib.concatStringsSep " " unknown}"
            else
              let unsupported = lib.subtractLists platformFeatures features; in
              if (unsupported != [])
                then throw "Feature(s) ${lib.concatStringsSep " " unsupported} are not supported on ${stdenv.hostPlatform.system}"
                else features;

    in stdenv.mkDerivation rec {
      pname = "mpd";
      version = "0.23.2";

      src = fetchFromGitHub {
        owner  = "MusicPlayerDaemon";
        repo   = "MPD";
        rev    = "v${version}";
        sha256 = "sha256-gn06t8S0hh5xe5V1vnXVHSb0FwxY40onUV+Bt7oL9ic=";
      };

      buildInputs = [
        glib
        boost
        fmt
        # According to the configurePhase of meson, gtest is considered a
        # runtime dependency. Quoting:
        #
        #    Run-time dependency GTest found: YES 1.10.0
        gtest
      ]
        ++ concatAttrVals features_ featureDependencies
        ++ lib.optionals stdenv.isDarwin [ AudioToolbox AudioUnit ];

      nativeBuildInputs = [
        meson
        ninja
        pkg-config
      ]
        ++ concatAttrVals features_ nativeFeatureDependencies;

      # Otherwise, the meson log says:
      #
      #    Program zip found: NO
      checkInputs = [ zip ];

      doCheck = true;

      mesonAutoFeatures = "disabled";

      outputs = [ "out" "doc" ]
        ++ lib.optional (builtins.elem "documentation" features_) "man";

      mesonFlags = [
        "-Dtest=true"
        "-Dmanpages=true"
        "-Dhtml_manual=true"
      ]
        ++ map (x: "-D${x}=enabled") features_
        ++ map (x: "-D${x}=disabled") (lib.subtractLists features_ knownFeatures)
        ++ lib.optional (builtins.elem "zeroconf" features_)
          "-Dzeroconf=avahi"
        ++ lib.optional (builtins.elem "systemd" features_)
          "-Dsystemd_system_unit_dir=etc/systemd/system";

      passthru.tests.nixos = nixosTests.mpd;

      meta = with lib; {
        description = "A flexible, powerful daemon for playing music";
        homepage    = "https://www.musicpd.org/";
        license     = licenses.gpl2Only;
        maintainers = with maintainers; [ astsmtl ehmry fpletz tobim ];
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
    "webdav" "curl" "mms" "bzip2" "zzip"
    "audiofile" "faad" "flac" "gme"
    "mpg123" "opus" "vorbis" "vorbisenc"
    "lame" "libsamplerate" "shout"
    "libmpdclient" "id3tag" "expat" "pcre"
    "yajl" "sqlite"
    "soundcloud" "qobuz" "tidal"
  ] ++ lib.optionals stdenv.isLinux [
    "alsa" "systemd" "syslog" "io_uring"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "mad" "jack" "nfs"
  ]; };
  mpdWithFeatures = run;
}
