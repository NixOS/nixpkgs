{ stdenv, pkgs, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "haproxy";
  majorVersion = "1.7";
  minorVersion = "2";
  version = "${majorVersion}.${minorVersion}";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.haproxy.org/download/${majorVersion}/src/${name}.tar.gz";
    sha256 = "0bsb5q3s1k5gqybv5p8zyvl6zh8iyidv3jb3wfmgwqad5bsl0nzr";
  };

  buildInputs = [ openssl zlib ];

  # TODO: make it work on bsd as well
  preConfigure = ''
    export makeFlags="TARGET=${if stdenv.isSunOS then "solaris" else if stdenv.isLinux then "linux2628" else "generic"} PREFIX=$out USE_OPENSSL=yes USE_ZLIB=yes ${stdenv.lib.optionalString stdenv.isDarwin "CC=cc USE_KQUEUE=1"}"
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
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    license = stdenv.lib.licenses.gpl2;
  };
}
