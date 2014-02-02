{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "dhcpcd-6.2.1";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/dhcpcd/${name}.tar.bz2";
    sha256 = "1gs23zwhzml2aam4j6rdncaqfv3z5n1ifx6lq4b8ccifqa87gbga";
  };

  patches = [ ./lxc_ro_promote_secondaries.patch ];

  buildInputs = [ pkgconfig udev ];

  configureFlags = "--sysconfdir=/etc";

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  # Check that the udev plugin got built.
  postInstall = "[ -e $out/lib/dhcpcd/dev/udev.so ]";

  meta = {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = http://roy.marples.name/projects/dhcpcd;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
