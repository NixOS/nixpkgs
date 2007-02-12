{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "iptables-1.3.7";
  src = fetchurl {
    url = http://www.netfilter.org/projects/iptables/files/iptables-1.3.7.tar.bz2;
    sha256 = "00nffc03akgm5p0skz90nl29h5d8b9fjc0d9lhipkbwy0ahcw00f";
  };
  preBuild = "makeFlagsArray=(PREFIX=$out)";
}
