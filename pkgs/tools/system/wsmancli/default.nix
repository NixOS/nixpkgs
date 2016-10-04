{ fetchurl, stdenv, autoconf, automake, libtool, pkgconfig, openwsman, openssl }:

stdenv.mkDerivation rec {
  version = "2.6.0";
  name = "wsmancli-${version}";

  src = fetchurl {
    url = "https://github.com/Openwsman/wsmancli/archive/v${version}.tar.gz";
    sha256 = "03ay6sa4ii8h6rr3l2qiqqml8xl6gplrlg4v2avdh9y6sihfyvvn";
  };

  buildInputs = [ autoconf automake libtool pkgconfig openwsman openssl ];

  preConfigure = ''
    ./bootstrap

    configureFlagsArray=(
      LIBS="-L${openssl.out}/lib -lssl -lcrypto"
    )
  '';

  meta = {
    description = "Openwsman command-line client";

    longDescription =
      '' Openwsman provides a command-line tool, wsman, to perform basic
         operations on the command-line. These operations include Get, Put,
         Invoke, Identify, Delete, Create, and Enumerate. The command-line tool
         also has several switches to allow for optional features of the
         WS-Management specification and Testing.
      '';

    homepage = https://github.com/Openwsman/wsmancli;
    downloadPage = "https://github.com/Openwsman/wsmancli/releases";

    maintainers = [ stdenv.lib.maintainers.deepfire ];

    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice

    inherit version;
  };
}
