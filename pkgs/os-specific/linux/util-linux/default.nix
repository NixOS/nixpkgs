{ stdenv, fetchurl, pkgconfig, zlib, ncurses ? null, perl ? null, pam, systemd }:

stdenv.mkDerivation rec {
  name = "util-linux-${version}";
  version = "2.28";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${version}/${name}.tar.xz";
    sha512 = "251zv6lk6b8ip38w2h0w2rpnly38nzh96945mbpssvwjv8fgr5bnhj3207aingyybik79761zngk981wl0rblq5f7l5v655znyi3yd1";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
  ];

  outputs = [ "bin" "out" "man" ]; # TODO: $bin is kept the first for now
  # due to lots of ${utillinux}/bin occurences and headers being rather small
  outputDev = "bin";


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
    --disable-use-tty-group
    --enable-fs-paths-default=/var/setuid-wrappers:/var/run/current-system/sw/bin:/sbin
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
    ++ stdenv.lib.optional (ncurses != null) ncurses
    ++ stdenv.lib.optional (systemd != null) [ systemd pkgconfig ]
    ++ stdenv.lib.optional (perl != null) perl;

  postInstall = ''
    rm "$bin/bin/su" # su should be supplied by the su package (shadow)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
    license = licenses.gpl2; # also contains parts under more permissive licenses
    platforms = platforms.linux;
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
