{ stdenv, fetchurl, flex, systemd, perl }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "drbd-8.4.4";

  src = fetchurl {
    url = "http://oss.linbit.com/drbd/8.4/${name}.tar.gz";
    sha256 = "1w4889h1ak7gy9w33kd4fgjlfpgmp6hzfya16p1pkc13bjf22mm0";
  };

  patches = [ ./pass-force.patch ];

  buildInputs = [ flex perl ];

  configureFlags = "--without-distro --without-pacemaker --localstatedir=/var --sysconfdir=/etc";

  preConfigure =
    ''
      export PATH=${systemd.udev.bin}/sbin:$PATH
      substituteInPlace user/Makefile.in \
        --replace /sbin '$(sbindir)'
      substituteInPlace user/legacy/Makefile.in \
        --replace '$(DESTDIR)/lib/drbd' '$(DESTDIR)$(LIBDIR)'
      substituteInPlace user/drbdadm_usage_cnt.c --replace /lib/drbd $out/lib/drbd
      substituteInPlace scripts/drbd.rules --replace /usr/sbin/drbdadm $out/sbin/drbdadm
    '';

  makeFlags = "SHELL=${stdenv.shell}";

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc INITDIR=$(out)/etc/init.d";

  meta = {
    homepage = http://www.drbd.org/;
    description = "Distributed Replicated Block Device, a distributed storage system for Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
