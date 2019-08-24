{ stdenv, fetchurl, pkgconfig, bison, flex
, libmnl, libnftnl, libpcap
, gmp, jansson, readline
, withXtables ? false , iptables
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.1";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.bz2";
    sha256 = "1kjg3dykf2aw76d76viz1hm0rav57nfbdwlngawgn2slxmlbplza";
  };

  configureFlags = [
    "--disable-man-doc"
    "--with-json"
  ] ++ optional withXtables "--with-xtables";

  nativeBuildInputs = [ pkgconfig bison flex ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp readline jansson
  ] ++ optional withXtables iptables;

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
