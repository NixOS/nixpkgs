{ stdenv, fetchurl, bison, flex, pkgconfig
, libnetfilter_conntrack, libnftnl, libmnl }:

stdenv.mkDerivation rec {
  name = "iptables-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "0l6yx3vym3qbvzq20gvpfirfz79h3v1bnzil5syf95j2ghcgmjy4";
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
    license = licenses.gpl2;
    downloadPage = "http://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    inherit version;
  };
}
