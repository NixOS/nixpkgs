{ lib, stdenv, fetchurl, pkg-config, zlib, shadow
, capabilitiesSupport ? true
, libcap_ng
, ncursesSupport ? true
, ncurses
, pamSupport ? true
, pam
, systemdSupport ? stdenv.isLinux && !stdenv.hostPlatform.isStatic
, systemd
, nlsSupport ? true
, translateManpages ? true
, po4a
}:

stdenv.mkDerivation rec {
  pname = "util-linux" + lib.optionalString (!nlsSupport && !ncursesSupport && !systemdSupport) "-minimal";
  version = "2.38";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/util-linux-${version}.tar.xz";
    hash = "sha256-bREcvk1VszbbLx++/7xluJkIcEwBE2Nx0yqpvsNz62Q=";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
  ];

  outputs = [ "bin" "dev" "out" "lib" "man" ];
  separateDebugInfo = true;

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
    (lib.withFeature ncursesSupport "ncursesw")
    (lib.withFeature systemdSupport "systemd")
    (lib.withFeatureAs systemdSupport
       "systemdsystemunitdir" "${placeholder "bin"}/lib/systemd/system/")
    (lib.enableFeature translateManpages "poman")
    "SYSCONFSTATICDIR=${placeholder "lib"}/lib"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "scanf_cv_type_modifier=ms"
  ;

  makeFlags = [
    "usrbin_execdir=${placeholder "bin"}/bin"
    "usrlib_execdir=${placeholder "lib"}/lib"
    "usrsbin_execdir=${placeholder "bin"}/sbin"
  ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals translateManpages [ po4a ];

  buildInputs = [ zlib ]
    ++ lib.optionals pamSupport [ pam ]
    ++ lib.optionals capabilitiesSupport [ libcap_ng ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals systemdSupport [ systemd ];

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
