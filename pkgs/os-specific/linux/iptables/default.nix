{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-1.4.4";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "0vsv3011cssra1cj9rag3z6m9ca7jaikphr26hvj0qnijbcp90pk";
  };

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
  };
}
