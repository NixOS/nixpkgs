{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  pkg-config,
  autoreconfHook,

  # `ps` with systemd support is able to properly report different
  # attributes like unit name, so we want to have it on linux.
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,

  # procps is mostly Linux-only. Most commands require a running Linux
  # system (or very similar like that found in Cygwin). The one
  # exception is ‘watch’ which is portable enough to run on pretty much
  # any UNIX-compatible system.
  watchOnly ? !(stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isCygwin),

  binlore,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "procps";
  version = "4.0.4";

  # The project's releases are on SF, but git repo on gitlab.
  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/procps-ng-${finalAttrs.version}.tar.xz";
    hash = "sha256-IocNb+skeK22F85PCaeHrdry0mDFqKp7F9iJqWLF5C4=";
  };

  buildInputs = [ ncurses ] ++ lib.optionals withSystemd [ systemdLibs ];
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  makeFlags = [ "usrbin_execdir=$(out)/bin" ] ++ lib.optionals watchOnly [ "src/watch" ];

  enableParallelBuilding = true;

  # Too red; 8bit support for fixing https://github.com/NixOS/nixpkgs/issues/275220
  configureFlags = [
    "--disable-modern-top"
    "--enable-watch8bit"
  ]
  ++ lib.optionals withSystemd [ "--with-systemd" ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ "--disable-w" ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  installPhase = lib.optionalString watchOnly ''
    runHook preInstall

    install -m 0755 -D src/watch $out/bin/watch
    install -m 0644 -D man/watch.1 $out/share/man/man1/watch.1

    runHook postInstall
  '';

  # no obvious exec in documented arguments; haven't trawled source
  # to figure out what exec binlore hits on
  passthru.binlore.out = binlore.synthesize procps ''
    execer cannot bin/{ps,top,free}
  '';

  meta = {
    homepage = "https://gitlab.com/procps-ng/procps";
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 11; # less than coreutils, which also provides "kill" and "uptime"
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
