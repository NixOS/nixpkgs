{ lib, stdenv, fetchurl, pkgconfig, zlib, fetchpatch, shadow
, ncurses ? null, perl ? null, pam, systemd, minimal ? false }:

let
  version = lib.concatStringsSep "." ([ majorVersion ]
    ++ lib.optional (patchVersion != "") patchVersion);
  majorVersion = "2.31";
  patchVersion = "1";

in stdenv.mkDerivation rec {
  name = "util-linux-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${majorVersion}/${name}.tar.xz";
    sha256 = "04fzrnrr3pvqskvjn9f81y0knh0jvvqx4lmbz5pd4lfdm5pv2l8s";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
    (fetchpatch {
      name = "CVE-2018-7738.diff";
      url = "https://github.com/karelzak/util-linux/commit/75f03badd7ed9.diff";
      sha256 = "0b8x1s7b9bh9p8a99bpdgjbqzqwsvb7l7cf3yy83jip1c38p685w";
    })
  ];

  outputs = [ "bin" "dev" "out" "man" ];

  postPatch = ''
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$out/bin/umount"
  '';

  crossAttrs = {
    # Work around use of `AC_RUN_IFELSE'.
    preConfigure = "export scanf_cv_type_modifier=ms";
  };

  preConfigure = lib.optionalString (systemd != null) ''
    configureFlags+=" --with-systemd --with-systemdsystemunitdir=$bin/lib/systemd/system/"
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
    "--enable-fs-paths-default=/run/wrappers/bin:/var/run/current-system/sw/bin:/sbin"
    "--disable-makeinstall-setuid" "--disable-makeinstall-chown"
  ]
    ++ lib.optional (ncurses == null) "--without-ncurses";

  makeFlags = "usrbin_execdir=$(bin)/bin usrsbin_execdir=$(bin)/sbin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    [ zlib pam ]
    ++ lib.filter (p: p != null) [ ncurses systemd perl ];

  postInstall = ''
    rm "$bin/bin/su" # su should be supplied by the su package (shadow)
  '' + lib.optionalString minimal ''
    rm -rf $out/share/{locale,doc,bash-completion}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
    license = licenses.gpl2; # also contains parts under more permissive licenses
    platforms = platforms.linux;
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
