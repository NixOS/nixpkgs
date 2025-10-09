{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bison,
  flex,
  asciidoc,
  libxslt,
  findXMLCatalogs,
  docbook_xml_dtd_45,
  docbook_xsl,
  libmnl,
  libnftnl,
  libpcap,
  gmp,
  jansson,
  autoreconfHook,
  withDebugSymbols ? false,
  withCli ? true,
  libedit,
  withXtables ? true,
  iptables,
  nixosTests,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "1.1.5";
  pname = "nftables";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${pname}-${version}.tar.xz";
    hash = "sha256-Ha8Q8yLhT9kKAXU4qvLANNfMHrHMQY3tR0RdcU6haNQ=";
  };

  patches = [
    (fetchurl {
      name = "musl.patch";
      url = "https://lore.kernel.org/netfilter-devel/20241219231001.1166085-2-hi@alyssa.is/raw";
      hash = "sha256-7vMBIoDWcI/JBInYP5yYWp8BnYbATRfMTxqyZr2L9Sk=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
    libxslt
  ];

  buildInputs = [
    libmnl
    libnftnl
    libpcap
    gmp
    jansson
  ]
  ++ lib.optional withCli libedit
  ++ lib.optional withXtables iptables;

  configureFlags = [
    "--with-json"
    (lib.withFeatureAs withCli "cli" "editline")
  ]
  ++ lib.optional (!withDebugSymbols) "--disable-debug"
  ++ lib.optional withXtables "--with-xtables";

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) firewall-nftables;
    nat = { inherit (nixosTests.nat.nftables) firewall standalone; };
  };

  passthru.updateScript = gitUpdater {
    url = "https://git.netfilter.org/nftables";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
    mainProgram = "nft";
  };
}
