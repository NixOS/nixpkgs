{stdenv, fetchurl, ncurses, libpcap, automake}:

stdenv.mkDerivation rec {
  name = "iftop-0.17";

  src = fetchurl {
    url = http://ex-parrot.com/pdw/iftop/download/iftop-0.17.tar.gz;
    sha256 = "1b0fis53280qx85gldhmqfcpgyiwplzg43gxyngia1w3f1y58cnh";
  };

  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} config
  '';

  buildInputs = [ncurses libpcap];

  meta = {
    description = "iftop does for network usage what top(1) does for CPU usage. It listens to network traffic on a named interface and displays a table of current bandwidth usage by pairs of hosts.";

    license = "GPLv2+";
    homepage = http://ex-parrot.com/pdw/iftop/;
  };
}
