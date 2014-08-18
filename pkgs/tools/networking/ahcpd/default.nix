{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ahcpd-0.53";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${name}.tar.gz";
    sha256 = "0lhdmky3zdyk51hclv2lrhw3hzymbdc8bw2khs3rnaibgn0jwqm4";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
    sed -i -e s,etc,$out/etc, Makefile
  '';

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/ahcp/";
    description = "Autoconfiguration protocol for IPv6 and dual-stack IPv6/IPv4 networks";
    license = stdenv.lib.licenses.mit;
  };
}
