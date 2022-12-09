{ lib, stdenv, fetchurl, pkg-config, bison, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, libedit
, autoreconfHook
, withDebugSymbols ? false
, withPython ? false , python3
, withXtables ? true , iptables
}:

stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.xz";
    hash = "sha256-JAdDDd2CmHZw5I3C/anigLqoMHq+wEqxjWCd89sAXkw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config bison flex
    asciidoc docbook_xml_dtd_45 docbook_xsl findXMLCatalogs libxslt
  ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp jansson libedit
  ] ++ lib.optional withXtables iptables
    ++ lib.optional withPython python3;

  patches = [ ./fix-py-libnftables.patch ];

  postPatch = ''
    substituteInPlace "py/nftables.py" \
      --subst-var-by "out" "$out"
  '';

  configureFlags = [
    "--with-json"
    "--with-cli=editline"
  ] ++ lib.optional (!withDebugSymbols) "--disable-debug"
    ++ lib.optional (!withPython) "--disable-python"
    ++ lib.optional withPython "--enable-python"
    ++ lib.optional withXtables "--with-xtables";

  meta = with lib; {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ajs124 ];
    mainProgram = "nft";
  };
}
