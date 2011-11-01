{ stdenv, fetchurl, flex, udev }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "drbd-8.4.0";

  src = fetchurl {
    url = "http://oss.linbit.com/drbd/8.4/${name}.tar.gz";
    sha256 = "096njwxjpwvnl259gxq6cr6n0r6ba0h5aryvgk05hqi95jx927vg";
  };

  buildInputs = [ flex ];

  configureFlags = "--without-distro --without-legacy_utils --without-pacemaker --localstatedir=/var --sysconfdir=/etc";

  preConfigure =
    ''
      export PATH=${udev}/sbin:$PATH
      substituteInPlace user/Makefile.in --replace /sbin/ $out/sbin/
      substituteInPlace scripts/drbd.rules --replace /sbin/drbdadm $out/sbin/drbdadm
    '';

  makeFlags = "SHELL=${stdenv.shell}";

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc INITDIR=$(out)/etc/init.d";

  meta = {
    homepage = http://www.drbd.org/;
    description = "Distributed Replicated Block Device, a distributed storage system for Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
