{ stdenv, fetchurl, fetchpatch, bison, flex, pkgconfig, pruneLibtoolFiles
, libnetfilter_conntrack, libnftnl, libmnl, libpcap }:

stdenv.mkDerivation rec {
  name = "iptables-${version}";
  version = "1.8.2";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "1bqj9hf3szy9r0w14iy23w00ir8448nfhpcprbwmcchsxm88nxx3";
  };

  patches = [
    # Adds missing bits to extensions' libipt_icmp.c and libip6t_icmp6.c that were causing build to fail
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=907e429d7548157016cd51aba4adc5d0c7d9f816";
      sha256 = "0vc7ljcglz5152lc3jx4p44vjfi6ipvxdrgkdb5dmkhlb5v93i2h";
    })
    # Build with musl libc fails because of conflicting struct ethhdr definitions
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=51d374ba41ae4f1bb851228c06b030b83dd2092f";
      sha256 = "05fwrq03f9sm0v2bfwshbrg7pi2p978w1460arnmpay3135gj266";
    })
    # Extensions: libip6t_mh: fix bogus translation error
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=5839d7fe62ff667af7132fc7d589b386951f27b3";
      sha256 = "0578jn1ip710z9kijwg9g2vjq2kfrbafl03m1rgi4fasz215gvkf";
    })
    # Prevent headers collisions between linux and netfilter (in.h and in6.h)
    # Fixed upstream with two commits
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=8d9d7e4b9ef4c6e6abab2cf35c747d7ca36824bd";
      sha256 = "0q3wcspiqym1r6dg1jhg7h8hpvsjzx1k7cs39z36mzlbmj9lm0zb";
    })
    (fetchpatch {
      url = "https://git.netfilter.org/iptables/patch/?id=2908eda10bf9fc81119d4f3ad672c67918ab5955";
      sha256 = "1dci4c8b7gcdrf77l2aicrcwlbp320xjz76fhavams0b4kgs6yr3";
    })
  ];

  nativeBuildInputs = [ bison flex pkgconfig pruneLibtoolFiles ];

  buildInputs = [ libnetfilter_conntrack libnftnl libmnl libpcap ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmnl -lnftnl"
  '';

  configureFlags = [
    "--enable-devel"
    "--enable-shared"
    "--enable-bpf-compiler"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = https://www.netfilter.org/projects/iptables/index.html;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    inherit version;
  };
}
