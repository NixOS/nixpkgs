let

# the default list from v1.8.5, except with applications/mod_signalwire also disabled
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
];

in

{ fetchurl, stdenv, lib, ncurses, curl, pkgconfig, gnutls, readline
, openssl, perl, sqlite, libjpeg, speex, pcre
, ldns, libedit, yasm, which, lua, libopus, libsndfile, libtiff

, modules ? defaultModules
, postgresql
, enablePostgres ? true

, SystemConfiguration
}:

let

availableModules = import ./modules.nix { inherit curl lua libopus; };

enabledModules = modules availableModules;

modulesConf = let
  lst = builtins.map (mod: mod.path) enabledModules;
  str = lib.strings.concatStringsSep "\n" lst;
  in builtins.toFile "modules.conf" str;

in

stdenv.mkDerivation rec {
  name = "freeswitch-1.8.5";

  src = fetchurl {
    url = "https://files.freeswitch.org/freeswitch-releases/${name}.tar.bz2";
    sha256 = "00xdrx84pw2v5pw1r5gfbb77nmvlfj275pmd48yfrc9g8c91j1sr";
  };
  postPatch = ''
    patchShebangs     libs/libvpx/build/make/rtcd.pl
    substituteInPlace libs/libvpx/build/make/configure.sh \
      --replace AS=\''${AS} AS=yasm
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    openssl ncurses gnutls readline perl libjpeg
    sqlite pcre speex ldns libedit yasm which
    libsndfile libtiff
  ]
  ++ lib.unique (lib.concatMap (mod: mod.inputs) enabledModules)
  ++ lib.optionals enablePostgres [ postgresql ]
  ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "format" ];

  configureFlags = lib.optionals enablePostgres [ "--enable-core-pgsql-support" ];

  preConfigure = ''
    cp "${modulesConf}" modules.conf
  '';

  postInstall = ''
    # helper for compiling modules... not generally useful; also pulls in perl dependency
    rm "$out"/bin/fsxs
  '';

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = https://freeswitch.org/;
    license = stdenv.lib.licenses.mpl11;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
