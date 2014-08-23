{ stdenv, fetchurl, libpcap }:

stdenv.mkDerivation rec {
  name = "ngrep-1.45";

  src = fetchurl {
    url = "mirror://sourceforge/ngrep/${name}.tar.bz2";
    sha256 = "19rg8339z5wscw877mz0422wbsadds3mnfsvqx3ihy58glrxv9mf";
  };

  buildInputs = [ libpcap ];

  preConfigure = ''
    # Fix broken test for BPF header file
    sed -i "s|BPF=.*|BPF=${libpcap}/include/pcap/bpf.h|" configure

    configureFlags="$configureFlags --with-pcap-includes=${libpcap}/include"
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
