{ lib, stdenv, fetchurl, pkgconfig, zlib, shadow
, ncurses ? null, perl ? null, pam, systemd ? null, minimal ? false }:

let
  version = lib.concatStringsSep "." ([ majorVersion ]
    ++ lib.optional (patchVersion != "") patchVersion);
  majorVersion = "2.33";
  patchVersion = "";

in stdenv.mkDerivation rec {
  name = "util-linux-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${majorVersion}/${name}.tar.xz";
    sha256 = "12k54fj1wz1193kq619vplvzj7gf8yn42sfj0kmfxgrm7kbvjqgj";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
  ];

  outputs = [ "bin" "dev" "out" "man" ];

  postPatch = ''
    patchShebangs tests/run.sh

    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$out/bin/umount"
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
    (lib.withFeature (ncurses != null) "ncursesw")
    (lib.withFeature (systemd != null) "systemd")
    (lib.withFeatureAs (systemd != null)
       "systemdsystemunitdir" "$(bin)/lib/systemd/system/")
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "scanf_cv_type_modifier=ms"
  ;

  makeFlags = "usrbin_execdir=$(bin)/bin usrsbin_execdir=$(bin)/sbin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    [ zlib pam ]
    ++ lib.filter (p: p != null) [ ncurses systemd perl ];

  doCheck = false; # "For development purpose only. Don't execute on production system!"

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
