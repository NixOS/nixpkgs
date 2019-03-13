{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, systemd, boost, darwin
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
, icu, sqlite, avah, dbus
# Services
, yajl
# Client support
, mpd_clientlib
# Tag support
, libid3tag
}:

let
  major = "0.20";
  minor = "23";

  lib = stdenv.lib;
  mkFlag = c: f: if c then "--enable-${f}" else "--disable-${f}";
  mkDisable = f: "--disable-${f}";
  mkEnable = f: "--enable-${f}";
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
    aac           = [ faad2 ];
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
    vorbis_encoder = [ libvorbis ];
    lame_encoder  = [ lame ];
    # Filter plugins
    lsr           = [ libsamplerate ];
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
    soundcloud    = [ yajl ];
    # Client support
    libmpdclient  = [ mpd_clientlib ];
    # Tag support
    id3           = [ libid3tag ];
    # Debug
    debug         = [];
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
    sha256 = "1z1pdgiddimnmck0ardrpxkvgk1wn9zxri5wfv5ppasbb7kfm350";
  };

  patches = [ ./x86.patch ];

  buildInputs = [ glib boost ]
    ++ (lib.concatLists (lib.attrVals features_ featureDependencies))
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreAudioKit
    ++ lib.optional stdenv.isLinux systemd;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  configureFlags =
    map mkEnable features_ ++ map mkDisable (lib.subtractLists features_ (keys featureDependencies))
    ++ [
      (mkFlag stdenv.isDarwin "osx")
    ]
    ++ lib.optional (lib.any (x: x == "zeroconf") features_)
      "--with-zeroconf=avahi"
    ++ lib.optional stdenv.isLinux
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system";

  NIX_LDFLAGS = ''
    ${if (lib.any (x: x == "shout") features_) then "-lshout" else ""}
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
