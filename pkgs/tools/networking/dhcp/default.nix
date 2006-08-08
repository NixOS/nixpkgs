{stdenv, fetchurl, groff, nettools, coreutils, iputils, gnused, bash}:

stdenv.mkDerivation {
  name = "dhcp-3.0.4";
  builder=./builder.sh;
  src = fetchurl {
    url = http://ftp.isc.org/isc/dhcp/dhcp-3.0.4.tar.gz;
    md5 = "004ef935fd54b8046b16bdde31a9e151";
  };
  buildInputs = [groff];
  inherit nettools coreutils iputils gnused bash;
  patches = [./dhcp-3.0.3-path.patch ./dhcp-3.0.3-bash.patch];
}
