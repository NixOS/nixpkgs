{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "iptables-1.4.1.1";

  src = fetchurl {
    url = http://www.netfilter.org/projects/iptables/files/iptables-1.4.1.1.tar.bz2;
    sha256 = "10mmf0d2gpshhi5a73z1y14wdh7pdk3hvn78ps5i37qayv6irqgr";
  };

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
  };
}
