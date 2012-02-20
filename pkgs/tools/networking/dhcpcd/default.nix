{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dhcpcd-5.5.4";

  src = fetchurl {
    url = "http://roy.marples.name/downloads/dhcpcd/${name}.tar.bz2";
    sha256 = "1zhpm89s6bk29lx7hq5f6fqm7i6dq2wq9vv5m25rv5wv6747v0m6";
  };

  configureFlags = "--sysconfdir=/etc";

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  meta = {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = http://roy.marples.name/projects/dhcpcd;
  };
}
