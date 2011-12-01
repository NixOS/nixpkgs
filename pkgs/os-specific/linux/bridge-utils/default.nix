{ stdenv, fetchurl, autoconf, automake }:

let
  name = "bridge-utils-1.5";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/bridge/${name}.tar.gz";
    sha256 = "42f9e5fb8f6c52e63a98a43b81bd281c227c529f194913e1c51ec48a393b6688";
  };

  buildInputs = [ autoconf automake ];

  preConfigure = "autoreconf";

  meta = {
    description = "http://sourceforge.net/projects/bridge/";
    homepage = [ "http://www.linux-foundation.org/en/Net:Bridge/" "http://sourceforge.net/projects/bridge/" ];
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
