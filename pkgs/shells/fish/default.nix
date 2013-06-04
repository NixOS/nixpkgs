{ stdenv, fetchurl, autoconf, ncurses, which }:

stdenv.mkDerivation rec {
  name = "fish-2.0.0";

  src = fetchurl {
    url = http://fishshell.com/files/2.0.0/fish-2.0.0.tar.gz;
    sha1 = "2d28553e2ff975f8e5fed6b266f7a940493b6636";
  };

  nativeBuildInputs = [ autoconf ];

  buildInputs = [ ncurses which ];

  preConfigure = ''
    autoconf
  '';

  meta = {
    homepage = http://fishshell.com;
  };
}