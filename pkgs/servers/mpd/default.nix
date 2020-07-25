{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, glib, systemd, boost, darwin
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
, nixosTests
# For documentation
, doxygen
, python3Packages # for sphinx-build
# For tests
, gtest
, fetchpatch # used to fetch an upstream patch fixing a failing test
, zip
}:

let
  lib = stdenv.lib;

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
    syslog        = [ ];
    systemd       = [ systemd ];
    yajl          = [ yajl ];
    zeroconf      = [ avahi dbus ];
  };

  run = { features ? null }:
    let
      # Disable platform specific features if needed
      # using libmad to decode mp3 files on darwin is causing a segfault -- there
      # is probably a solution, but I'm disabling it for now
      platformMask = lib.optionals stdenv.isDarwin [ "mad" "pulse" "jack" "nfs" "smbclient" ]
                  ++ lib.optionals (!stdenv.isLinux) [ "alsa" "systemd" "syslog" ];

      knownFeatures = builtins.attrNames featureDependencies;
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
      version = "0.21.25";

      src = fetchFromGitHub {
        owner  = "MusicPlayerDaemon";
        repo   = "MPD";
        rev    = "v${version}";
        sha256 = "1yjp8pwr2zn0mp39ls1w0pl37zrjn5m9ycgjmcsw2wpa4709r356";
      };

      buildInputs = [
        glib
        boost
        # According to the configurePhase of meson, gtest is considered a
        # runtime dependency. Quoting:
        #
        #    Run-time dependency GTest found: YES 1.10.0
        gtest
      ]
        ++ (lib.concatLists (lib.attrVals features_ featureDependencies))
        ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AudioToolbox darwin.apple_sdk.frameworks.AudioUnit ];

      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        python3Packages.sphinx
        doxygen
      ];

      # Otherwise, the meson log says:
      #
      #    Program zip found: NO
      checkInputs = [ zip ];

      doCheck = true;

      enableParallelBuilding = true;

      mesonAutoFeatures = "disabled";

      outputs = [ "out" "doc" "man" ];

      mesonFlags = [
        # Documentation is enabled unconditionally but it's not installed
        # unconditionally thanks to the outputs being split
        "-Ddocumentation=true"
        "-Dtest=true"
      ]
        ++ map (x: "-D${x}=enabled") features_
        ++ map (x: "-D${x}=disabled") (lib.subtractLists features_ knownFeatures)
        ++ lib.optional (builtins.elem "zeroconf" features_)
          "-Dzeroconf=avahi"
        ++ lib.optional (builtins.elem "systemd" features_)
          "-Dsystemd_system_unit_dir=etc/systemd/system";

      passthru.tests.nixos = nixosTests.mpd;

      meta = with stdenv.lib; {
        description = "A flexible, powerful daemon for playing music";
        homepage    = "https://www.musicpd.org/";
        license     = licenses.gpl2;
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
    "audiofile" "faad" "flac" "gme" "mad"
    "mpg123" "opus" "vorbis" "vorbisenc"
    "lame" "libsamplerate" "shout"
    "libmpdclient" "id3tag" "expat" "pcre"
    "yajl" "sqlite"
    "soundcloud" "qobuz" "tidal"
  ] ++ lib.optionals stdenv.isLinux [
    "alsa" "systemd" "syslog"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "mad" "jack" "nfs"
  ]; };
  mpdWithFeatures = run;
}
