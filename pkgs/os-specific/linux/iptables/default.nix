{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-1.4.16.2";

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    md5 = "57220bb26866a713073e5614f88071fc";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
