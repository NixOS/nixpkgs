<<<<<<< HEAD
{ useLua ? true
, usePcre ? true
, withPrometheusExporter ? true
, stdenv
, lib
, fetchurl
, nixosTests
, openssl
, zlib
, libxcrypt
, lua5_3 ? null
, pcre ? null
, systemd ? null
=======
{ useLua ? !stdenv.isDarwin
, usePcre ? true
, withPrometheusExporter ? true
, stdenv, lib, fetchurl, nixosTests
, openssl, zlib, libxcrypt
, lua5_3 ? null, pcre ? null, systemd ? null
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "haproxy";
  version = "2.8.2";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/haproxy-${finalAttrs.version}.tar.gz";
    hash = "sha256-aY1pBtFwlGqGl2mWTleBa6PaOt9h/3XomXKxN/RljbA=";
=======
stdenv.mkDerivation rec {
  pname = "haproxy";
  version = "2.7.8";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-FfInaXG7uoxH2GzILr/G7DPjrvLkVlBYsuSVDAe451w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ openssl zlib libxcrypt ]
    ++ lib.optional useLua lua5_3
    ++ lib.optional usePcre pcre
    ++ lib.optional stdenv.isLinux systemd;

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=${placeholder "out"}"
<<<<<<< HEAD
    ("TARGET=" + (if stdenv.isSunOS then "solaris"
    else if stdenv.isLinux then "linux-glibc"
    else if stdenv.isDarwin then "osx"
    else "generic"))
=======
    ("TARGET=" + (if stdenv.isSunOS  then "solaris"
             else if stdenv.isLinux  then "linux-glibc"
             else if stdenv.isDarwin then "osx"
             else "generic"))
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/CHANGELOG";
    description = "Reliable, high performance TCP/HTTP load balancer";
    homepage = "https://haproxy.org";
    license = with lib.licenses; [ gpl2Plus lgpl21Only ];
=======
  meta = with lib; {
    description = "Reliable, high performance TCP/HTTP load balancer";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "haproxy";
  };
})
=======
    homepage = "https://haproxy.org";
    changelog = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/CHANGELOG";
    license = with licenses; [ gpl2Plus lgpl21Only ];
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux ++ darwin;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
