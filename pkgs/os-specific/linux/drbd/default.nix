{ stdenv, fetchurl, flex, udev, perl }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "drbd-8.4.4";

  src = fetchurl {
    url = "http://oss.linbit.com/drbd/8.4/${name}.tar.gz";
    sha256 = "0hm1cnd7vsccyc22sg85f9aj48nijl2f1kgbvl5crv414ihv5giq";
  };

  patches = [ ./pass-force.patch ];

  buildInputs = [ flex perl ];

  configureFlags = "--without-distro --without-pacemaker --localstatedir=/var --sysconfdir=/etc";

  preConfigure =
    ''
      export PATH=${udev}/sbin:$PATH
      substituteInPlace user/Makefile.in --replace /sbin/ $out/sbin/
      substituteInPlace user/legacy/Makefile.in \
        --replace /sbin/ $out/sbin/ \
        --replace '$(DESTDIR)/lib/drbd' $out/lib/drbd
      substituteInPlace user/drbdadm_usage_cnt.c --replace /lib/drbd $out/lib/drbd
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
