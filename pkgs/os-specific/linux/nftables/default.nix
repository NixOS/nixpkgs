{ lib, stdenv, fetchurl, pkg-config, bison, flex
, asciidoc, libxslt, findXMLCatalogs, docbook_xml_dtd_45, docbook_xsl
, libmnl, libnftnl, libpcap
, gmp, jansson, libedit
, autoreconfHook
, withDebugSymbols ? false
<<<<<<< HEAD
, withPython ? false, python3
, withXtables ? true, iptables
, nixosTests
}:

stdenv.mkDerivation rec {
  version = "1.0.8";
=======
, withPython ? false , python3
, withXtables ? true , iptables
}:

stdenv.mkDerivation rec {
  version = "1.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.xz";
<<<<<<< HEAD
    hash = "sha256-k3N0DeQagtvJiBjgpGoHP664qNBon6T6GnQ5nDK/PVA=";
=======
    hash = "sha256-wSrJQf/5ra7fFzZ9XOITeJuYoNMUJ3vCKz1x4QiR9BI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    ++ lib.optionals withPython [
      python3
      python3.pkgs.setuptools
    ];
=======
    ++ lib.optional withPython python3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureFlags = [
    "--with-json"
    "--with-cli=editline"
  ] ++ lib.optional (!withDebugSymbols) "--disable-debug"
    ++ lib.optional (!withPython) "--disable-python"
    ++ lib.optional withPython "--enable-python"
    ++ lib.optional withXtables "--with-xtables";

<<<<<<< HEAD
  passthru.tests = {
    inherit (nixosTests) firewall-nftables lxd-nftables;
    nat = { inherit (nixosTests.nat.nftables) firewall standalone; };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ajs124 ];
    mainProgram = "nft";
  };
}
