{ useLua ? !stdenv.isDarwin
, usePcre ? true
, stdenv, fetchurl
, openssl, zlib, lua5_3 ? null, pcre ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

stdenv.mkDerivation rec {
  pname = "haproxy";
  majorVersion = "1.7";
  minorVersion = "8";
  version = "${majorVersion}.${minorVersion}";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.haproxy.org/download/${majorVersion}/src/${name}.tar.gz";
    sha256 = "0hp1k957idaphhmw4m0x8cdzdw9ga1mzgsnk2m0as86xrqy1b47c";
  };

  buildInputs = [ openssl zlib ]
    ++ stdenv.lib.optional useLua lua5_3
    ++ stdenv.lib.optional usePcre pcre;

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
  ] ++ stdenv.lib.optionals usePcre [
    "USE_PCRE=yes"
    "USE_PCRE_JIT=yes"
  ] ++ stdenv.lib.optionals useLua [
    "USE_LUA=yes"
    "LUA_LIB=${lua5_3}/lib"
    "LUA_INC=${lua5_3}/include"
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
    maintainers = with stdenv.lib.maintainers; [ fuzzy-id garbas ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    license = stdenv.lib.licenses.gpl2;
  };
}
