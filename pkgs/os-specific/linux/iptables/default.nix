{ stdenv, fetchurl, bison, flex, pkgconfig
, libnetfilter_conntrack, libnftnl, libmnl }:

stdenv.mkDerivation rec {
  name = "iptables-${version}";
  version = "1.6.2";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "0crp0lvh5m2f15pr8cw97h8yb8zjj10x95zj06j46cr68vx2vl2m";
  };

  nativeBuildInputs = [ bison flex pkgconfig ];

  buildInputs = [ libnetfilter_conntrack libnftnl libmnl ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmnl -lnftnl"
  '';

  configureFlags = [
    "--enable-devel"
    "--enable-shared"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    downloadPage = "http://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    inherit version;
  };
}
