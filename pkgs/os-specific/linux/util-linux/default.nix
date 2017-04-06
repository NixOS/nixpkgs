{ lib, stdenv, fetchurl, pkgconfig, zlib, fetchpatch, shadow
, ncurses ? null, perl ? null, pam, systemd, minimal ? false }:

stdenv.mkDerivation rec {
  name = "util-linux-${version}";
  version = lib.concatStringsSep "." ([ majorVersion ]
    ++ lib.optional (patchVersion != "") patchVersion);
  majorVersion = "2.29";
  patchVersion = "2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${majorVersion}/${name}.tar.xz";
    sha256 = "1qz81w8vzrmy8xn9yx7ls4amkbgwx6vr62pl6kv9g7r0g3ba9kmc";
  };

  patches = [ ./rtcwake-search-PATH-for-shutdown.patch ];

  outputs = [ "bin" "dev" "out" "man" ];

  postPatch = ''
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
  '';

  crossAttrs = {
    # Work around use of `AC_RUN_IFELSE'.
    preConfigure = "export scanf_cv_type_modifier=ms";
  };

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = ''
    --enable-write
    --enable-last
    --enable-mesg
    --disable-use-tty-group
    --enable-fs-paths-default=/run/wrappers/bin:/var/run/current-system/sw/bin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
    ${if systemd == null then "" else ''
      --with-systemd
      --with-systemdsystemunitdir=$out/lib/systemd/system/
    ''}
  '';

  makeFlags = "usrbin_execdir=$(bin)/bin usrsbin_execdir=$(bin)/sbin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    [ zlib pam ]
    ++ lib.optional (ncurses != null) ncurses
    ++ lib.optional (systemd != null) systemd
    ++ lib.optional (perl != null) perl;

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
