{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "dhcpcd-6.9.1";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.xz";
    sha256 = "0vq6gjgn2sjq2rwvd23gvf55k2v9l6970z8fmii0p2g23w77afy0";
  };

  buildInputs = [ pkgconfig udev ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

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
