{ lib, stdenv, fetchurl, pkg-config, pruneLibtoolFiles, flex, bison
, libmnl, libnetfilter_conntrack, libnfnetlink, libnftnl, libpcap
, nftablesCompat ? true
}:

with lib;

stdenv.mkDerivation rec {
  version = "1.8.7";
  pname = "iptables";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "1w6qx3sxzkv80shk21f63rq41c84irpx68k62m2cv629n1mwj2f1";
  };

  nativeBuildInputs = [ pkg-config pruneLibtoolFiles flex bison ];

  buildInputs = [ libmnl libnetfilter_conntrack libnfnetlink libnftnl libpcap ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmnl -lnftnl"
  '';

  configureFlags = [
    "--enable-bpf-compiler"
    "--enable-devel"
    "--enable-libipq"
    "--enable-nfsynproxy"
    "--enable-shared"
  ] ++ optional (!nftablesCompat) "--disable-nftables";

  outputs = [ "out" "dev" ];

  postInstall = optionalString nftablesCompat ''
    rm $out/sbin/{iptables,iptables-restore,iptables-save,ip6tables,ip6tables-restore,ip6tables-save}
    ln -sv xtables-nft-multi $out/bin/iptables
    ln -sv xtables-nft-multi $out/bin/iptables-restore
    ln -sv xtables-nft-multi $out/bin/iptables-save
    ln -sv xtables-nft-multi $out/bin/ip6tables
    ln -sv xtables-nft-multi $out/bin/ip6tables-restore
    ln -sv xtables-nft-multi $out/bin/ip6tables-save
  '';

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = "https://www.netfilter.org/projects/iptables/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
  };
}
