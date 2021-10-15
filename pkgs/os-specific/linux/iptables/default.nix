{ lib, stdenv, pkg-config, pruneLibtoolFiles, flex, bison
, libmnl, libnetfilter_conntrack, libnfnetlink, libnftnl, libpcap
, fetchzip, nixosTests, nftablesCompat ? true
}:

with lib;

stdenv.mkDerivation rec {
  version = "1.8.7";
  pname = "iptables";

  src = fetchzip {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "hH7fDPyFAICI1LUNhB9H4di5S/7n+u8vLKb/aMb/5BA=";
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

  passthru.tests = nixosTests.iptables;

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = "https://www.netfilter.org/projects/iptables/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    longDescription = ''
      iptables is the userspace command line program used to configure the Linux 2.4.x and later packet filtering ruleset.
      It is targeted towards system administrators.

      Since Network Address Translation is also configured from the packet filter ruleset,
      iptables is used for this, too.

      The iptables package also includes ip6tables.
      ip6tables is used for configuring the IPv6 packet filter.
    '';
  };
}
