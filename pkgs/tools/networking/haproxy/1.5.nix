{ stdenv, pkgs, fetchurl, openssl }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  name = "haproxy-${version}";

  src = fetchurl {
    url = "http://www.haproxy.org/download/1.5/src/${name}.tar.gz";
    md5 = "e999a547d57445d5a5ab7eb6a06df9a1";
  };

  buildInputs = [ openssl ];

  # TODO: make it work on darwin/bsd as well
  preConfigure = ''
    export makeFlags="${if stdenv.isSunOS then "TARGET=solaris" else ""} PREFIX=$out USE_OPENSSL=1"
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
    platforms = stdenv.lib.platforms.unix;
    license = [
       stdenv.lib.licenses.gpl2
       stdenv.lib.licenses.lgpl21
    ];
  };
}
