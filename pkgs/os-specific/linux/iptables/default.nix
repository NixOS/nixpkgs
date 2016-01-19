{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iptables-${version}";
  version = "1.4.21"; # before updating check #12178

  src = fetchurl {
    url = "http://www.netfilter.org/projects/iptables/files/${name}.tar.bz2";
    sha256 = "1q6kg7sf0pgpq0qhab6sywl23cngxxfzc9zdzscsba8x09l4q02j";
  };

  configureFlags = ''
    --enable-devel
    --enable-shared
  '';

  meta = {
    description = "A program to configure the Linux IP packet filtering ruleset";
    homepage = http://www.netfilter.org/projects/iptables/index.html;
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://www.netfilter.org/projects/iptables/files/";
    updateWalker = true;
    inherit version;
  };
}
