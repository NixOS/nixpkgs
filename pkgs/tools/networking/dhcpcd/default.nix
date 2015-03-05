{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "dhcpcd-6.6.7";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.bz2";
    sha256 = "1aydp26xsn9y6acg5zmcz6pp6parywnmhcvp9ipf54vbac53mya3";
  };

  patches = [ /* ./lxc_ro_promote_secondaries.patch */ ];

  buildInputs = [ pkgconfig udev ];

  configureFlags = "--sysconfdir=/etc";

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  # Check that the udev plugin got built.
  postInstall = stdenv.lib.optional (udev != null) "[ -e $out/lib/dhcpcd/dev/udev.so ]";

  meta = {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = http://roy.marples.name/projects/dhcpcd;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
