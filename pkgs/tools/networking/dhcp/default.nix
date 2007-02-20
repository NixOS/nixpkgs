{stdenv, fetchurl, groff, nettools, coreutils, iputils, gnused, bash}:

stdenv.mkDerivation {
  name = "dhcp-3.0.5";
  builder=./builder.sh;
  src = fetchurl {
    url = http://ftp.isc.org/isc/dhcp/dhcp-3.0.5.tar.gz;
    sha256 = "1dpz6y08vrn3mw0lrlwq1sfiq6nsixpwwgb9hngddka1lfr5yi6x";
  };
  buildInputs = [groff];
  inherit nettools coreutils iputils gnused bash;
  patches = [./resolv-without-domain.patch];
}
