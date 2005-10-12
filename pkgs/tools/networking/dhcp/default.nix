{stdenv, fetchurl, groff, nettools, coreutils, iputils, gnused}:

stdenv.mkDerivation {
  name = "dhcp-3.0.3";
  builder=./builder.sh;
  src = fetchurl {
    url = ftp://ftp.isc.org/isc/dhcp/dhcp-3.0.3.tar.gz;
    md5 = "f91416a0b8ed3fd0601688cf0b7df58f";
  };
  buildInputs = [groff];
  inherit nettools coreutils iputils gnused;
  patches = [./dhcp-3.0.3-path.patch];
}
