{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, libpcap, pcre }:

stdenv.mkDerivation rec {
  pname = "ngrep";
  version = "1.47";

  src = fetchFromGitHub {
    owner = "jpr5";
    repo = "ngrep";
    rev = "V${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1x2fyd7wdqlj1r76ilal06cl2wmbz0ws6i3ys204sbjh1cj6dcl7";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/jpr5/ngrep/pull/11.patch";
      sha256 = "0k5qzvj8j3r1409qwwvzp7m3clgs2g7hs4q68bhrqbrsvvb2h5dh";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap pcre ];

  configureFlags = [
    "--enable-ipv6"
    "--enable-pcre"
    "--disable-pcap-restart"
    "--with-pcap-includes=${libpcap}/include"
  ];

  preConfigure = ''
    sed -i "s|BPF=.*|BPF=${libpcap}/include/pcap/bpf.h|" configure
  '';

  meta = with lib; {
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
    homepage = "https://github.com/jpr5/ngrep/";
    # <ngrep>/doc/README.txt says that ngrep itself is licensed under a
    # 'BSD-like' license but that the 'regex' library (in the ngrep tarball) is
    # GPLv2.
    license = "ngrep";  # Some custom BSD-style, see LICENSE.txt
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
