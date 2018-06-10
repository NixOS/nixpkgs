{ stdenv
, fetchFromGitLab

, cmake
, ninja

, libxslt
, libxml2

, enableSSL ? true
, enableMonitor ? false
, enableRproxy ? true
, enableTomahawk ? false
, enableXSLT ? true
, enableToolkit ? true
}:

stdenv.mkDerivation rec {
  name = "hiawatha-${version}";
  version = "10.8.1";

  src = fetchFromGitLab {
    owner = "hsleisink";
    repo = "hiawatha";
    rev = "v${version}";
    sha256 = "1428byx0xpzzwyc0j157q70sjx18dykvg6fd5vp70kj85ank0xpa";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ libxslt libxml2 ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace SETUID ""
  '';

  cmakeFlags = [
    (
      # FIXME: 2018-06-08: Uses bundled library, with external ("-DUSE_SYSTEM_MBEDTLS=on") asks:
      # ../src/tls.c:46:2: error: #error "The mbed TLS library must be compiled with MBEDTLS_THREADING_PTHREAD and MBEDTLS_THREADING_C enabled."
      if enableSSL then "-DENABLE_TLS=on" else "-DENABLE_TLS=off" )
    ( if enableMonitor then "-DENABLE_MONITOR=on" else "-DENABLE_MONITOR=off" )
    ( if enableRproxy then "-DENABLE_RPROXY=on" else "-DENABLE_RPROXY=off" )
    ( if enableTomahawk then "-DENABLE_TOMAHAWK=on" else "-DENABLE_TOMAHAWK=off" )
    ( if enableXSLT then "-DENABLE_XSLT=on" else "-DENABLE_XSLT=off" )
    ( if enableToolkit then "-DENABLE_TOOLKIT=on" else "-DENABLE_TOOLKIT=off" )
  ];

  meta = with stdenv.lib; {
    description = "An advanced and secure webserver";
    license = licenses.gpl2;
    homepage = https://www.hiawatha-webserver.org;
    maintainers = [ maintainers.ndowens ];
  };

}
