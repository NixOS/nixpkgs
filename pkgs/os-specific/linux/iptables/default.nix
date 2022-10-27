{ lib, stdenv, fetchurl, pkg-config, pruneLibtoolFiles, flex, bison
, libmnl, libnetfilter_conntrack, libnfnetlink, libnftnl, libpcap
, nftablesCompat ? true
, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "1.8.8";
  pname = "iptables";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ccdYidxxBnZjFVPrFRHaAXe7qvG1USZbkS0jbD9RhZ8=";
  };

  patches = [
    # xshared: Fix build for -Werror=format-security
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=b72eb12ea5a61df0655ad99d5048994e916be83a";
      sha256 = "sha256-pnamqOagwNWoiwlxPnKCqSc2N7MP/eZlT7JiE09c8OE=";
    })
    # treewide: use uint* instead of u_int*
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=f319389525b066b7dc6d389c88f16a0df3b8f189";
      sha256 = "sha256-rOxCEWZoI8Ac5fQDp286YHAwvreUAoDVAbomboKrGyM=";
    })
    # fix Musl build
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=0e7cf0ad306cdf95dc3c28d15a254532206a888e";
      sha256 = "18mnvqfxzd7ifq3zjb4vyifcyadpxdi8iqcj8wsjgw23n49lgrbj";
    })
  ];

  outputs = [ "out" "dev" "man" ];

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
  ] ++ lib.optional (!nftablesCompat) "--disable-nftables";

  postInstall = lib.optionalString nftablesCompat ''
    rm $out/sbin/{iptables,iptables-restore,iptables-save,ip6tables,ip6tables-restore,ip6tables-save}
    ln -sv xtables-nft-multi $out/bin/iptables
    ln -sv xtables-nft-multi $out/bin/iptables-restore
    ln -sv xtables-nft-multi $out/bin/iptables-save
    ln -sv xtables-nft-multi $out/bin/ip6tables
    ln -sv xtables-nft-multi $out/bin/ip6tables-restore
    ln -sv xtables-nft-multi $out/bin/ip6tables-save
  '';

  meta = with lib; {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = "https://www.netfilter.org/projects/iptables/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
  };
}
