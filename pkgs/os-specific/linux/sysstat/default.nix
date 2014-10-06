{ stdenv, fetchurl, gettext, bzip2 }:

stdenv.mkDerivation rec {
  name = "sysstat-11.0.1";

  src = fetchurl {
    url = "http://perso.orange.fr/sebastien.godard/${name}.tar.xz";
    sha256 = "1cwgsxvs7jkr3il6r344mw46502yjnhrsbcp4217vh4b7xv6czaq";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2}/bin/bzip2
    export SYSTEMCTL=systemctl
    makeFlagsArray=(SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y CHOWN=true)
    installFlagsArray=(SA_DIR=$TMPDIR/dummy)
    # Note: --enable-install-cron actually installs systemd units.
    configureFlagsArray+=(--with-systemdsystemunitdir=$out/lib/systemd/system --enable-install-cron)
  '';

  preInstall = ''
    mkdir -p $out/lib/systemd/system
  '';

  meta = {
    homepage = http://sebastien.godard.pagesperso-orange.fr/;
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
