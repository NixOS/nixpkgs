{ lib, stdenv, fetchurl, pkgconfig, zlib, libseccomp, fetchpatch, autoreconfHook, ncurses ? null, perl ? null, pam, systemd, minimal ? false }:

stdenv.mkDerivation rec {
  name = "util-linux-${version}";
  version = lib.concatStringsSep "." ([ majorVersion ]
    ++ lib.optional (patchVersion != "") patchVersion);
  majorVersion = "2.29";
  patchVersion = "";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${majorVersion}/${name}.tar.xz";
    sha256 = "1rzrmdrz51p9sy7vlw5qmj8pmqazm7hgcch5yq242mkvrikyln9c";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
    (fetchpatch {
      name = "CVE-2016-2779.diff";
      url = https://github.com/karelzak/util-linux/commit/8e4925016875c6a4f2ab4f833ba66f0fc57396a2.patch;
      sha256 = "0kmigkq4s1b1ijrq8vcg2a5cw4qnm065m7cb1jn1q1f4x99ycy60";
  })];

  outputs = [ "bin" "dev" "out" "man" ];

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

  # autoreconfHook is required for CVE-2016-2779
  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  # libseccomp is required for CVE-2016-2779
  buildInputs =
    [ zlib pam libseccomp ]
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
