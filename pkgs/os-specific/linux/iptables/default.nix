{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-1.4.6";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "193jdplnkzikrmk0y313d9alc4kp5gi55aikw3b668fnrac2fwvf";
  };

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
  };
}
