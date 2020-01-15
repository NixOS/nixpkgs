{ stdenv, fetchurl, bison, flex, pkgconfig, pruneLibtoolFiles
, libnetfilter_conntrack, libnftnl, libmnl, libpcap }:

stdenv.mkDerivation rec {
  pname = "iptables";
  version = "1.8.3";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "106xkkg5crsscjlinxvqvprva23fwwqfgrzl8m2nn841841sqg52";
  };

  nativeBuildInputs = [ bison flex pkgconfig pruneLibtoolFiles ];

  buildInputs = [ libnetfilter_conntrack libnftnl libmnl libpcap ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmnl -lnftnl"
  '';

  configureFlags = [
    "--enable-devel"
    "--enable-shared"
    "--enable-bpf-compiler"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = https://www.netfilter.org/projects/iptables/index.html;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    inherit version;
  };
}
