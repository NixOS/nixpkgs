{ lib, stdenv, pkg-config, bison, file, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, readline
, fetchzip, nixosTests
, withDebugSymbols ? false
, withPython ? false , python3
, withXtables ? true , iptables
}:

with lib;

stdenv.mkDerivation rec {
  version = "1.0.0";
  pname = "nftables";

  src = fetchzip {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.bz2";
    sha256 = "0h696szcgwzxlvwim5m5wi32jxi8fs20636yz01pmi175mpf6vsq";
  };

  nativeBuildInputs = [
    pkg-config bison file flex
    asciidoc docbook_xml_dtd_45 docbook_xsl findXMLCatalogs libxslt
  ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp jansson readline
  ] ++ optional withXtables iptables
    ++ optional withPython python3;

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "--with-json"
  ] ++ optional (!withDebugSymbols) "--disable-debug"
    ++ optional (!withPython) "--disable-python"
    ++ optional withPython "--enable-python"
    ++ optional withXtables "--with-xtables";

  passthru.tests = nixosTests.nftables;

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
    mainProgram = "nft";
    longDescription = ''
      nftables replaces the popular {ip,ip6,arp,eb}tables.
      This software provides a new in-kernel packet classification framework that is based
      on a network-specific Virtual Machine (VM) and a new nft userspace command line tool.
      nftables reuses the existing Netfilter subsystems such as the existing hook infrastructure,
      the connection tracking system, NAT, userspace queueing and logging subsystem.
    '';
  };
}
