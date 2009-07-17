{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "dhcpcd-5.0.6";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/dhcpcd/${name}.tar.bz2";
    sha256 = "0q8yz1kg9x031lnsvws010wawg0z85xv34575x1iavh3lrd90705";
  };

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db";

  meta = {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = http://roy.marples.name/projects/dhcpcd;
  };
}
