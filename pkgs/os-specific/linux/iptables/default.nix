{ lib, stdenv, fetchurl
, autoreconfHook, pkg-config, pruneLibtoolFiles, flex, bison
, libmnl, libnetfilter_conntrack, libnfnetlink, libnftnl, libpcap
, nftablesCompat ? true
, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "1.8.9";
  pname = "iptables";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
    sha256 = "72Y5pDvoMlpPjqaBI/+sI2y2lujHhQG2ToEGr7AIyH8=";
  };

  patches = [
    (fetchpatch {
      name = "format-security.patch";
      url = "https://git.netfilter.org/iptables/patch/?id=ed4082a7405a5838c205a34c1559e289949200cc";
      sha256 = "OdytFmHk+3Awu+sDQpGTl5/qip4doRblmW2vQzfNZiU=";
    })
    (fetchurl {
      name = "static.patch";
      url = "https://lore.kernel.org/netfilter-devel/20230402232939.1060151-1-hi@alyssa.is/raw";
      sha256 = "PkH+1HbJjBb3//ffBe0XUQok1lBwgj/STL8Ppu/28f4=";
    })
  ];

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    autoreconfHook pkg-config pruneLibtoolFiles flex bison
  ];

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
