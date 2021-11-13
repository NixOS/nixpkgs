{ lib, stdenv, fetchurl, gettext, bzip2 }:

stdenv.mkDerivation rec {
  pname = "sysstat";
  version = "12.4.3";

  src = fetchurl {
    url = "http://pagesperso-orange.fr/sebastien.godard/sysstat-${version}.tar.xz";
    sha256 = "sha256-rkMkMfRarLyrrPu+Ep4lBeIVyvqc6ZbXVQxgkaRvC/0=";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2.bin}/bin/bzip2
    export SYSTEMCTL=systemctl
  '';

  makeFlags = [ "SYSCONFIG_DIR=$(out)/etc" "IGNORE_FILE_ATTRIBUTES=y" "CHOWN=true" ];
  installTargets = [ "install_base" "install_nls" "install_man" ];

  patches = [ ./install.patch ];

  meta = {
    homepage = "http://sebastien.godard.pagesperso-orange.fr/";
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}
