{ useLua ? !stdenv.isDarwin
, usePcre ? true
, stdenv, fetchurl
, openssl, zlib, lua5_3 ? null, pcre ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

stdenv.mkDerivation rec {
  pname = "haproxy";
  version = "1.9.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${stdenv.lib.versions.majorMinor version}/src/${name}.tar.gz";
    sha256 = "0cln17gdv81xb24hkylw7addj1xxqnldhw82vnyc0gnc51klcnay";
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
  ] ++ stdenv.lib.optional stdenv.isDarwin "CC=cc"
    ++ stdenv.lib.optional stdenv.isLinux "USE_GETADDRINFO=1";

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
