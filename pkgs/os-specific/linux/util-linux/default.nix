{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null, pam }:

stdenv.mkDerivation rec {
  name = "util-linux-2.26";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v2.26/${name}.tar.xz";
    sha256 = "a23c6f39dea0ed215ccd589509ffc7bb6f706f6e1a04760f493fb0fd7e93c489";
  };

  patches = [ ./rtcwake-search-PATH-for-shutdown.patch
            ];

  #FIXME: make it also work on non-nixos?
  postPatch = ''
    # Substituting store paths would create a circular dependency on systemd
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "/run/current-system/sw/bin/login" \
      --replace "/sbin/shutdown" "/run/current-system/sw/bin/shutdown"
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
    --enable-ddate
    --disable-use-tty-group
    --enable-fs-paths-default=/var/setuid-wrappers:/var/run/current-system/sw/sbin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs =
    [ zlib pam ]
    ++ stdenv.lib.optional (ncurses != null) ncurses
    ++ stdenv.lib.optional (perl != null) perl;

  postInstall = ''
    rm $out/bin/su # su should be supplied by the su package (shadow)
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
