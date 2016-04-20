{ stdenv, fetchurl, qt4, ncurses }:

stdenv.mkDerivation rec {
  name = "i7z-0.27.2";

  src = fetchurl {
    url = "http://i7z.googlecode.com/files/${name}.tar.gz";
    sha256 = "1wa7ix6m75wl3k2n88sz0x8cckvlzqklja2gvzqfw5rcfdjjvxx7";
  };

  buildInputs = [ qt4 ncurses ];

  buildPhase = ''
    make
    cd GUI
    qmake
    make clean
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/sbin
    make install prefix=$out
    install -Dm755 GUI/i7z_GUI $out/sbin/i7z-gui
  '';

  meta = {
    description = "A better i7 (and now i3, i5) reporting tool for Linux";
    homepage = http://code.google.com/p/i7z;
    repositories.git = https://github.com/ajaiantilal/i7z.git;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
  };
}
