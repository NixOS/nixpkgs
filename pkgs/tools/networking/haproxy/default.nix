{ stdenv, pkgs, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  majorVersion = "1.6";
  version = "${majorVersion}.6";
  name = "haproxy-${version}";

  src = fetchurl {
    url = "http://haproxy.1wt.eu/download/${majorVersion}/src/${name}.tar.gz";
    sha256 = "1xamzzfvwgh3b72f3j74ar9xcn61viszqfbdpf4cdhwc0xikvc7x";
  };

  buildInputs = [ openssl zlib ];

  # TODO: make it work on darwin/bsd as well
  preConfigure = ''
    export makeFlags="TARGET=${if stdenv.isSunOS then "solaris" else "linux2628"} PREFIX=$out USE_OPENSSL=yes USE_ZLIB=yes"
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
    license = stdenv.lib.licenses.gpl2;
  };
}
