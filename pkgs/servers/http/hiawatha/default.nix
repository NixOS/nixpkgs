{ stdenv
, fetchFromGitLab

, cmake
, ninja
, mbedtls

, enableCache     ? true     # Internal cache support.
, enableIpV6      ? true
, enableTls       ? true
, enableMonitor   ? false    # Support for the Hiawatha Monitor.
, enableRproxy    ? true     # Reverse proxy support.
, enableTomahawk  ? false    # Tomahawk, the Hiawatha command shell.
, enableXslt      ? true, libxml2 ? null, libxslt ? null
, enableToolkit   ? true     # The URL Toolkit.
}:

stdenv.mkDerivation rec {
  pname = "hiawatha";
  version = "10.9";

  src = fetchFromGitLab {
    owner = "hsleisink";
    repo = "hiawatha";
    rev = "v${version}";
    sha256 = "0mcg36bidy3p57nyk9nliqjipfb3r2irziavlbr2d5g3smfv52z2";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ mbedtls ] ++ stdenv.lib.optionals enableXslt [ libxslt libxml2 ];

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

  meta = with stdenv.lib; {
    homepage = "https://www.hiawatha-webserver.org";
    description = "An advanced and secure webserver";
    license = licenses.gpl2;
    platforms = platforms.unix;    # "Hiawatha runs perfectly on Linux, BSD and MacOS X"
    maintainers = [];
  };

}
