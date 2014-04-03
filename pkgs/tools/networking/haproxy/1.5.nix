{ stdenv, pkgs, fetchurl, openssl }:

stdenv.mkDerivation rec {
  version = "1.5-dev22";
  name = "haproxy-${version}";

  src = fetchurl {
    url = "http://haproxy.1wt.eu/download/1.5/src/devel/${name}.tar.gz";
    md5 = "980332c79ab0ffa908c77fafdf61b8cc";
  };

  buildInputs = [ openssl ];

  # TODO: make it work on darwin/bsd as well
  preConfigure = ''
    export makeFlags="TARGET=solaris PREFIX=$out USE_OPENSSL=1"
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
