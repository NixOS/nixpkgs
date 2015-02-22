{ stdenv, pkgs, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.5.11";
  name = "haproxy-${version}";

  src = fetchurl {
    url = "http://haproxy.1wt.eu/download/1.5/src/${name}.tar.gz";
    sha256 = "1gwkyy06c8bw5vcjv82hai554zrd415jjsb1iafg01c4k1ia8nlb";
  };

  buildInputs = [ ];

  # TODO: make it work on darwin/bsd as well
  preConfigure = ''
    export makeFlags="TARGET=linux2628 PREFIX=$out"
  '';

  meta = {
    description = "Reliable, high performance TCP/HTTP load balancer";
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
    homepage = http://haproxy.1wt.eu;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
    /* TODO license = [
       stdenv.lib.licenses.gpl2
       stdenv.lib.licenses.lgpl21
    ];*/
  };
}
