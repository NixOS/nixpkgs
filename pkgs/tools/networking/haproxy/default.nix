{ useLua ? true
, usePcre ? true
# QUIC "is currently supported as an experimental feature" so shouldn't be enabled by default
, useQuicTls ? false
, withPrometheusExporter ? true
, stdenv
, lib
, fetchurl
, nixosTests
, zlib
, libxcrypt
, openssl ? null
, quictls ? null
, lua5_3 ? null
, pcre ? null
, systemd ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;
assert useQuicTls -> quictls != null;
assert !useQuicTls -> openssl != null;

let sslPkg = if useQuicTls then quictls else openssl;
in stdenv.mkDerivation (finalAttrs: {
  pname = "haproxy";
  version = "2.9.1";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/haproxy-${finalAttrs.version}.tar.gz";
    hash = "sha256-1YAcdyqrnEP0CWS3sztDiNFLW0V1C+TSZxeFhjzbnxw=";
  };

  buildInputs = [ sslPkg zlib libxcrypt ]
    ++ lib.optional useLua lua5_3
    ++ lib.optional usePcre pcre
    ++ lib.optional stdenv.isLinux systemd;

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    ("TARGET=" + (if stdenv.isSunOS then "solaris"
    else if stdenv.isLinux then "linux-glibc"
    else if stdenv.isDarwin then "osx"
    else "generic"))
  ];

  buildFlags = [
    "USE_OPENSSL=yes"
    "SSL_LIB=${sslPkg}/lib"
    "SSL_INC=${sslPkg}/include"
    "USE_ZLIB=yes"
  ] ++ lib.optionals useQuicTls [
    "USE_QUIC=1"
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

  meta = {
    changelog = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/CHANGELOG";
    description = "Reliable, high performance TCP/HTTP load balancer";
    homepage = "https://haproxy.org";
    license = with lib.licenses; [ gpl2Plus lgpl21Only ];
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "haproxy";
  };
})
