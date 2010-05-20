{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-1.4.8";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "1d6wykz1x2h0hp03akpm5gdgnamb1ij1nxzx3w3lhdvbzjwpbaxq";
  };

  # Install header files required by miniupnpd.
  postInstall =
    ''
      cp include/iptables.h $out/include
      cp include/libiptc/libiptc.h include/libiptc/ipt_kernel_headers.h $out/include/libiptc
      mkdir $out/include/iptables
      cp include/iptables/internal.h $out/include/iptables
      mkdir $out/include/net
      cp -prd include/net/netfilter $out/include/net/netfilter
      mkdir $out/include/linux
      ln -s $out/include/net/netfilter $out/include/linux/netfilter
    '';

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
  };
}
