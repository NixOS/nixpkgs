{ stdenv, fetchurl, bison, flex
, libnetfilter_conntrack, libnftnl, libmnl }:

stdenv.mkDerivation rec {
  name = "iptables-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "0q0w1x4aijid8wj7dg1ny9fqwll483f1sqw7kvkskd8q1c52mdsb";
  };

  nativeBuildInputs = [ bison flex ];

  buildInputs = [ libnetfilter_conntrack libnftnl libmnl ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmnl -lnftnl"
  '';

  configureFlags = ''
    --enable-devel
    --enable-shared
  '';

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
