{ lib, stdenv, fetchurl, pkgconfig, zlib, shadow
, ncurses ? null, perl ? null, pam, systemd ? null, minimal ? false }:

stdenv.mkDerivation rec {
  pname = "util-linux";
  version = "2.36";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1cg0m4psswg71v6wrqc2bngcw20fsp01vbijxdzvdf8kxdkiqjwy";
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

  nativeBuildInputs = [ pkgconfig ];
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
