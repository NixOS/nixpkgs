{stdenv, fetchurl, groff, nettools, coreutils, iputils, gnused, bash}:

stdenv.mkDerivation {
  name = "dhcp-3.0.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.isc.org/isc/dhcp/dhcp-3.0.6.tar.gz;
    sha256 = "0k8gy3ab9kzs4qcc9apgnxi982lhggha41fkw9w1bmvmz7mv0xwz";
  };
  buildInputs = [groff];
  inherit nettools coreutils iputils gnused bash;
  patches = [./resolv-without-domain.patch];
}
