{ useLua ? !stdenv.isDarwin
, usePcre ? true
, withPrometheusExporter ? true
, stdenv, lib, fetchurl, nixosTests
, openssl, zlib, libxcrypt
, lua5_3 ? null, pcre ? null, systemd ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

stdenv.mkDerivation rec {
  pname = "haproxy";
  version = "2.7.2";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-Y7xuwDAtDrvh+nacGWBmQN6DSsjLB0R7gHmctWPcDz8=";
  };

  buildInputs = [ openssl zlib libxcrypt ]
    ++ lib.optional useLua lua5_3
    ++ lib.optional usePcre pcre
    ++ lib.optional stdenv.isLinux systemd;

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    ("TARGET=" + (if stdenv.isSunOS  then "solaris"
             else if stdenv.isLinux  then "linux-glibc"
             else if stdenv.isDarwin then "osx"
             else "generic"))
  ];

  buildFlags = [
    "USE_OPENSSL=yes"
    "USE_ZLIB=yes"
  ] ++ lib.optionals usePcre [
    "USE_PCRE=yes"
    "USE_PCRE_JIT=yes"
  ] ++ lib.optionals useLua [
    "USE_LUA=yes"
    "LUA_LIB_NAME=lua"
    "LUA_LIB=${lua5_3}/lib"
    "LUA_INC=${lua5_3}/include"
  ] ++ lib.optionals stdenv.isLinux [
    "USE_SYSTEMD=yes"
    "USE_GETADDRINFO=1"
  ] ++ lib.optionals withPrometheusExporter [
    "USE_PROMEX=yes"
  ] ++ [ "CC=${stdenv.cc.targetPrefix}cc" ];

  enableParallelBuilding = true;

  passthru.tests.haproxy = nixosTests.haproxy;

  meta = with lib; {
    description = "Reliable, high performance TCP/HTTP load balancer";
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
    homepage = "https://haproxy.org";
    changelog = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/CHANGELOG";
    license = with licenses; [ gpl2Plus lgpl21Only ];
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux ++ darwin;
  };
}
