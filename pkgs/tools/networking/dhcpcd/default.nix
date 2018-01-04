{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "dhcpcd-7.0.0";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.xz";
    sha256 = "1m90wsg4m9bcaavh36vlhjghrbdsi5x2yy92ixhgynmzrgnwlqdb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

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
    homepage = https://roy.marples.name/projects/dhcpcd;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ eelco fpletz ];
  };
}
