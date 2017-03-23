{ stdenv, pkgs, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "haproxy";
  majorVersion = "1.7";
  minorVersion = "3";
  version = "${majorVersion}.${minorVersion}";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.haproxy.org/download/${majorVersion}/src/${name}.tar.gz";
    sha256 = "ebb31550a5261091034f1b6ac7f4a8b9d79a8ce2a3ddcd7be5b5eb355c35ba65";
  };

  buildInputs = [ openssl zlib ];

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=\${out}"
    ("TARGET=" + (if stdenv.isSunOS  then "solaris"
             else if stdenv.isLinux  then "linux2628"
             else if stdenv.isDarwin then "osx"
             else "generic"))
  ];
  buildFlags = [
    "USE_OPENSSL=yes"
    "USE_ZLIB=yes"
  ] ++ stdenv.lib.optional stdenv.isDarwin "CC=cc";

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
