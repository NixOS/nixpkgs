{ lib
, stdenv
, fetchurl
, ncurses
, pkg-config
, fetchpatch

  # `ps` with systemd support is able to properly report different
  # attributes like unit name, so we want to have it on linux.
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd

  # procps is mostly Linux-only. Most commands require a running Linux
  # system (or very similar like that found in Cygwin). The one
  # exception is ‘watch’ which is portable enough to run on pretty much
  # any UNIX-compatible system.
, watchOnly ? !(stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isCygwin)

, binlore
, procps
}:

stdenv.mkDerivation rec {
  pname = "procps";
  version = "3.3.17";

  # The project's releases are on SF, but git repo on gitlab.
  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/procps-ng-${version}.tar.xz";
    sha256 = "sha256-RRiz56r9NOwH0AY9JQ/UdJmbILIAIYw65W9dIRPxQbQ=";
  };

  patches = [
    ./v3-CVE-2023-4016.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    # NOTE: Starting from 4.x we will not need a patch anymore, but need to add
    # "--disable-w" to configureFlags instead to prevent the utmp errors
    (fetchpatch {
      name = "musl-fix-includes.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/procps/musl-fixes.patch?id=37cb5b6ef194db66d9ed07c8ecab59bca3b91215";
      sha256 = "sha256-DphAvESmVg1U3bJABU95R++QD34odStCl82EF0vmht0=";
    })
  ];

  buildInputs = [ ncurses ]
    ++ lib.optional withSystemd systemd;
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "usrbin_execdir=$(out)/bin" ]
    ++ lib.optionals watchOnly [ "watch" "PKG_LDFLAGS=" ];

  enableParallelBuilding = true;

  # Too red; 8bit support for fixing https://github.com/NixOS/nixpkgs/issues/275220
  configureFlags = [ "--disable-modern-top" "--enable-watch8bit" ]
    ++ lib.optional withSystemd "--with-systemd"
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  installPhase = lib.optionalString watchOnly ''
    install -m 0755 -D watch $out/bin/watch
    install -m 0644 -D watch.1 $out/share/man/man1/watch.1
  '';

  # no obvious exec in documented arguments; haven't trawled source
  # to figure out what exec binlore hits on
  passthru.binlore.out = binlore.synthesize procps ''
    execer cannot bin/{ps,top,free}
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/procps-ng/procps";
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 11; # less than coreutils, which also provides "kill" and "uptime"
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.typetetris ];
  };
}
