{ fetchFromGitHub
, fetchpatch
, stdenv
, lib
, pkg-config
, autoreconfHook
, ncurses
, gnutls
, readline
, openssl
, perl
, sqlite
, libjpeg
, speex
, pcre
, libuuid
, ldns
, libedit
, yasm
, which
, libsndfile
, libtiff
, libxcrypt
, callPackage
, SystemConfiguration
, modules ? null
, nixosTests
}:

let

availableModules = callPackage ./modules.nix { };

# the default list from v1.8.7, except with applications/mod_signalwire also disabled
defaultModules = mods: with mods; [
  applications.commands
  applications.conference
  applications.db
  applications.dptools
  applications.enum
  applications.esf
  applications.expr
  applications.fifo
  applications.fsv
  applications.hash
  applications.httapi
  applications.sms
  applications.spandsp
  applications.valet_parking
  applications.voicemail

  applications.curl

  codecs.amr
  codecs.b64
  codecs.g723_1
  codecs.g729
  codecs.h26x
  codecs.opus

  databases.mariadb
  databases.pgsql

  dialplans.asterisk
  dialplans.xml

  endpoints.loopback
  endpoints.rtc
  endpoints.skinny
  endpoints.sofia
  endpoints.verto

  event_handlers.cdr_csv
  event_handlers.cdr_sqlite
  event_handlers.event_socket

  formats.local_stream
  formats.native_file
  formats.png
  formats.sndfile
  formats.tone_stream

  languages.lua

  loggers.console
  loggers.logfile
  loggers.syslog

  say.en

  xml_int.cdr
  xml_int.rpc
  xml_int.scgi
] ++ lib.optionals stdenv.isLinux [ endpoints.gsmopen ];

enabledModules = (if modules != null then modules else defaultModules) availableModules;

modulesConf = let
  lst = builtins.map (mod: mod.path) enabledModules;
  str = lib.strings.concatStringsSep "\n" lst;
  in builtins.toFile "modules.conf" str;

in

stdenv.mkDerivation rec {
  pname = "freeswitch";
  version = "1.10.11";
  src = fetchFromGitHub {
    owner = "signalwire";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LzGqrXzPED3PoCDnrwUmmSQsvlAucYo2gTkwFausM7A=";
  };

  postPatch = ''
    patchShebangs     libs/libvpx/build/make/rtcd.pl
    substituteInPlace libs/libvpx/build/make/configure.sh \
      --replace AS=\''${AS} AS=yasm

    # Disable advertisement banners
    for f in src/include/cc.h libs/esl/src/include/cc.h; do
      {
        echo 'const char *cc = "";'
        echo 'const char *cc_s = "";'
      } > $f
    done
  '';

  strictDeps = true;
  nativeBuildInputs = [ pkg-config autoreconfHook perl which yasm ];
  buildInputs = [
    openssl ncurses gnutls readline libjpeg
    sqlite pcre speex ldns libedit
    libsndfile libtiff
    libuuid libxcrypt
  ]
  ++ lib.unique (lib.concatMap (mod: mod.inputs) enabledModules)
  ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # Using c++14 because of build error
  # gsm_at.h:94:32: error: ISO C++17 does not allow dynamic exception specifications
  CXXFLAGS = "-std=c++14";

  CFLAGS = "-D_ANSI_SOURCE";

  hardeningDisable = [ "format" ];

  preConfigure = ''
    ./bootstrap.sh
    cp "${modulesConf}" modules.conf
  '';

  postInstall = ''
    # helper for compiling modules... not generally useful; also pulls in perl dependency
    rm "$out"/bin/fsxs
    # include configuration templates
    cp -r conf $out/share/freeswitch/
  '';

  passthru.tests.freeswitch = nixosTests.freeswitch;

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = "https://freeswitch.org/";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    platforms = with lib.platforms; unix;
    broken = stdenv.isDarwin;
  };
}
