{ stdenv, fetchurl, fetchpatch, libpcap, gnumake3, pcre }:

stdenv.mkDerivation rec {
  name = "ngrep-1.45";

  src = fetchurl {
    url = "mirror://sourceforge/ngrep/${name}.tar.bz2";
    sha256 = "19rg8339z5wscw877mz0422wbsadds3mnfsvqx3ihy58glrxv9mf";
  };

  patches = [
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/users/rfrancoise/ngrep.git/plain/debian/patches/10_debian-build.diff?h=debian/1.45.ds2-14";
      sha256 = "1p359k54xjbh6r0d0lv1l679n250wxk6j8yyz23gn54kwdc29zfy";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/users/rfrancoise/ngrep.git/plain/debian/patches/10_man-fixes.diff?h=debian/1.45.ds2-14";
      sha256 = "1b66zfbsrsvg60j988i6ga9iif1c34fsbq3dp1gi993xy4va8m5k";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/users/rfrancoise/ngrep.git/plain/debian/patches/20_setlocale.diff?h=debian/1.45.ds2-14";
      sha256 = "16xbmnmvw5sjidz2qhay68k3xad05g74nrccflavxbi0jba52fdq";
    })
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/users/rfrancoise/ngrep.git/plain/debian/patches/40_ipv6-offsets.diff?h=debian/1.45.ds2-14";
      sha256 = "0fjlk1sav5nnjapvsa8mvdwjkhgm3kgc6dw7r9h1qx6d3b8cgl76";
    })
  ];

  buildInputs = [ gnumake3 libpcap pcre ];

  preConfigure = ''
    # Fix broken test for BPF header file
    sed -i "s|BPF=.*|BPF=${libpcap}/include/pcap/bpf.h|" configure

    configureFlags="$configureFlags --enable-ipv6 --enable-pcre --disable-pcap-restart --with-pcap-includes=${libpcap}/include"
  '';

  meta = with stdenv.lib; {
    description = "Network packet analyzer";
    longDescription = ''
      ngrep strives to provide most of GNU grep's common features, applying
      them to the network layer. ngrep is a pcap-aware tool that will allow you
      to specify extended regular or hexadecimal expressions to match against
      data payloads of packets. It currently recognizes IPv4/6, TCP, UDP,
      ICMPv4/6, IGMP and Raw across Ethernet, PPP, SLIP, FDDI, Token Ring and
      null interfaces, and understands BPF filter logic in the same fashion as
      more common packet sniffing tools, such as tcpdump and snoop.
    '';
    homepage = http://ngrep.sourceforge.net/;
    # <ngrep>/doc/README.txt says that ngrep itself is licensed under a
    # 'BSD-like' license but that the 'regex' library (in the ngrep tarball) is
    # GPLv2.
    license = "ngrep";  # Some custom BSD-style, see LICENSE.txt
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
