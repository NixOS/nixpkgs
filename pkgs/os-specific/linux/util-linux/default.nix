{ lib, stdenv, fetchurl, fetchpatch, pkg-config, zlib, shadow
, ncurses ? null, perl ? null, pam, systemd ? null, minimal ? false }:

stdenv.mkDerivation rec {
  pname = "util-linux";
  version = "2.36.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1vbyydl1b13lx73di4bhc4br9ih24hcqv7bky0kyrn1c2x1c5yh9";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
    # Remove patch below in 2.36.2, see https://github.com/karelzak/util-linux/issues/1193
    (fetchpatch {
      url = "https://github.com/karelzak/util-linux/commit/52f730e47869ce630fafb24fd46f755dc7ffc691.patch";
      sha256 = "1fz3p9127lfvmrdj1j1s8jds0jjz2dzkvmia66555ihv7hcfajbg";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" ];

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
    "--enable-write"
    "--enable-last"
    "--enable-mesg"
    "--disable-use-tty-group"
    "--enable-fs-paths-default=/run/wrappers/bin:/run/current-system/sw/bin:/sbin"
    "--disable-makeinstall-setuid" "--disable-makeinstall-chown"
    "--disable-su" # provided by shadow
    (lib.withFeature (ncurses != null) "ncursesw")
    (lib.withFeature (systemd != null) "systemd")
    (lib.withFeatureAs (systemd != null)
       "systemdsystemunitdir" "${placeholder "bin"}/lib/systemd/system/")
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "scanf_cv_type_modifier=ms"
  ;

  makeFlags = [
    "usrbin_execdir=${placeholder "bin"}/bin"
    "usrsbin_execdir=${placeholder "bin"}/sbin"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ zlib pam ]
    ++ lib.filter (p: p != null) [ ncurses systemd perl ];

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  postInstall = lib.optionalString minimal ''
    rm -rf $out/share/{locale,doc,bash-completion}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "A set of system utilities for Linux";
    license = licenses.gpl2; # also contains parts under more permissive licenses
    platforms = platforms.linux;
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
