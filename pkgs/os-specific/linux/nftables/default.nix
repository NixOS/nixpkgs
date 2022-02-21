{ lib, stdenv, fetchurl, pkg-config, bison, file, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, libedit
, autoreconfHook, fetchpatch
, withDebugSymbols ? false
, withPython ? false , python3
, withXtables ? true , iptables
}:

with lib;

stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.bz2";
    sha256 = "00jcjn1pl7qyqpg8pd4yhlkys7wbj4vkzgg73n27nmplzips6a0b";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config bison file flex
    asciidoc docbook_xml_dtd_45 docbook_xsl findXMLCatalogs libxslt
  ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp jansson libedit
  ] ++ optional withXtables iptables
    ++ optional withPython python3;

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  patches = [
    # fix build after 1.0.2 release, drop when updating to a newer release
    (fetchpatch {
      url = "https://git.netfilter.org/nftables/patch/?id=18a08fb7f0443f8bde83393bd6f69e23a04246b3";
      sha256 = "03dzhd7fhg0d20ly4rffk4ra7wlxp731892dhp8zw67jwhys9ywz";
    })
  ];

  configureFlags = [
    "--with-json"
    "--with-cli=editline"
  ] ++ optional (!withDebugSymbols) "--disable-debug"
    ++ optional (!withPython) "--disable-python"
    ++ optional withPython "--enable-python"
    ++ optional withXtables "--with-xtables";

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ajs124 ];
  };
}
