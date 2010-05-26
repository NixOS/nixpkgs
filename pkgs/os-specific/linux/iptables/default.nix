{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-1.4.8";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "342926b3f9635f89f479660835b0ba518ccd465552e41c29aa83c5af7d506496";
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
    '';

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
  };
}
