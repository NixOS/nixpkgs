{ lib, stdenv
, fetchFromGitLab
, callPackage

, cmake
, ninja
, mbedtls
, libxcrypt

, enableCache     ? true     # Internal cache support.
, enableIpV6      ? true
, enableTls       ? true
, enableMonitor   ? false    # Support for the Hiawatha Monitor.
, enableRproxy    ? true     # Reverse proxy support.
, enableTomahawk  ? false    # Tomahawk, the Hiawatha command shell.
, enableXslt      ? true, libxml2 ? null, libxslt ? null
, enableToolkit   ? true     # The URL Toolkit.
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiawatha";
  version = "11.6";

  src = fetchFromGitLab {
    owner = "hsleisink";
    repo = "hiawatha";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YsZdVqanVNibA4KnAknLh61hVo7x5uu67lb+RX2N7c8=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ mbedtls libxcrypt ] ++ lib.optionals enableXslt [ libxslt libxml2 ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace SETUID ""
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_MBEDTLS=on" # Policy to use Nix deps, and Nix uses up to date deps
    ( if enableCache     then "-DENABLE_CACHE=on"       else "-DENABLE_CACHE=off"       )
    ( if enableIpV6      then "-DENABLE_IPV6=on"        else "-DENABLE_IPV6=off"        )
    ( if enableTls       then "-DENABLE_TLS=on"         else "-DENABLE_TLS=off"         )
    ( if enableMonitor   then "-DENABLE_MONITOR=on"     else "-DENABLE_MONITOR=off"     )
    ( if enableRproxy    then "-DENABLE_RPROXY=on"      else "-DENABLE_RPROXY=off"      )
    ( if enableTomahawk  then "-DENABLE_TOMAHAWK=on"    else "-DENABLE_TOMAHAWK=off"    )
    ( if enableXslt      then "-DENABLE_XSLT=on"        else "-DENABLE_XSLT=off"        )
    ( if enableToolkit   then "-DENABLE_TOOLKIT=on"     else "-DENABLE_TOOLKIT=off"     )
  ];

  passthru.tests.serve-static-files = callPackage ./test.nix {
    hiawatha = finalAttrs.finalPackage;
    inherit enableTls;
  };

  meta = with lib; {
    homepage = "https://hiawatha.leisink.net/";
    description = "Advanced and secure webserver";
    license = licenses.gpl2Only;
    platforms = platforms.unix;    # "Hiawatha runs perfectly on Linux, BSD and MacOS X"
    mainProgram = "hiawatha";
    maintainers = [ ];
  };

})
