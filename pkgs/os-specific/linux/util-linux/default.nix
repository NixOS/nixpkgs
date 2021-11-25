{ lib, stdenv, fetchurl, pkg-config, zlib, shadow, libcap_ng
, ncurses ? null, pam, systemd ? null
, nlsSupport ? true
, audit ? null
}:

assert stdenv.hostPlatform.isStatic -> audit != null;

stdenv.mkDerivation rec {
  pname = "util-linux";
  version = "2.37.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-agdkwarn+2B++KbdLA9sR9Xl/SeqCIIKuq2ewU4o6dk=";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
  ];

  outputs = [ "bin" "dev" "out" "lib" "man" ];

  postPatch = ''
    patchShebangs tests/run.sh

    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$bin/bin/umount"
  '';

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = [
    "--localstatedir=/var"
    "--enable-write"
    "--disable-use-tty-group"
    "--enable-fs-paths-default=/run/wrappers/bin:/run/current-system/sw/bin:/sbin"
    "--disable-makeinstall-setuid" "--disable-makeinstall-chown"
    "--disable-su" # provided by shadow
    (lib.enableFeature nlsSupport "nls")
    (lib.withFeature (ncurses != null) "ncursesw")
    (lib.withFeature (systemd != null) "systemd")
    (lib.withFeatureAs (systemd != null)
       "systemdsystemunitdir" "${placeholder "bin"}/lib/systemd/system/")
    "SYSCONFSTATICDIR=${placeholder "lib"}/lib"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "scanf_cv_type_modifier=ms"
  ;

  makeFlags = [
    "usrbin_execdir=${placeholder "bin"}/bin"
    "usrlib_execdir=${placeholder "lib"}/lib"
    "usrsbin_execdir=${placeholder "bin"}/sbin"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ zlib pam libcap_ng ]
    ++ lib.filter (p: p != null) [ ncurses systemd ]
    # not sure how util-linux is linking with linux-pam,
    # probably just with a simplistic -lpam.
    # linux-pam doesn't seem to have a .pc file so I can't
    # add -laudit to the Requires.private.
    # libaudit is also needed directly anyway cf login-utils/login.c
    # and sys-utils/hwclock.c, not sure how we got it working
    # without audit on dynamic builds.
    ++ lib.optionals stdenv.hostPlatform.isStatic [ audit ];

  NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isStatic "-laudit";

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "A set of system utilities for Linux";
    changelog = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${lib.versions.majorMinor version}/v${version}-ReleaseNotes";
    # https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/README.licensing
    license = with licenses; [ gpl2Only gpl2Plus gpl3Plus lgpl21Plus bsd3 bsdOriginalUC publicDomain ];
    platforms = platforms.linux;
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
