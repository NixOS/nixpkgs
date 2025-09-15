{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  pruneLibtoolFiles,
  flex,
  bison,
  libmnl,
  libnetfilter_conntrack,
  libnfnetlink,
  libnftnl,
  libpcap,
  bash,
  bashNonInteractive,
  nftablesCompat ? true,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "1.8.11";
  pname = "iptables";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
    sha256 = "2HMD1V74ySvK1N0/l4sm0nIBNkKwKUJXdfW60QCf57I=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pruneLibtoolFiles
    flex
    bison
  ];

  buildInputs = [
    libmnl
    libnetfilter_conntrack
    libnfnetlink
    libnftnl
    libpcap
    bash
  ];

  configureFlags = [
    "--enable-bpf-compiler"
    "--enable-devel"
    "--enable-libipq"
    "--enable-nfsynproxy"
    "--enable-shared"
  ]
  ++ lib.optional (!nftablesCompat) "--disable-nftables";

  enableParallelBuilding = true;

  postInstall = lib.optionalString nftablesCompat ''
    rm $out/sbin/{iptables,iptables-restore,iptables-save,ip6tables,ip6tables-restore,ip6tables-save}
    ln -sv xtables-nft-multi $out/bin/iptables
    ln -sv xtables-nft-multi $out/bin/iptables-restore
    ln -sv xtables-nft-multi $out/bin/iptables-save
    ln -sv xtables-nft-multi $out/bin/ip6tables
    ln -sv xtables-nft-multi $out/bin/ip6tables-restore
    ln -sv xtables-nft-multi $out/bin/ip6tables-save
  '';

  outputChecks.lib.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://git.netfilter.org/iptables";
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Program to configure the Linux IP packet filtering ruleset";
    homepage = "https://www.netfilter.org/projects/iptables/index.html";
    platforms = platforms.linux;
    mainProgram = "iptables";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
  };
}
