{ stdenv, fetchurl, qt4, ncurses}:

stdenv.mkDerivation rec {
  name = "i7z-0.27.1";

  src = fetchurl {
    url = "http://i7z.googlecode.com/files/${name}.tar.gz";
    sha256 = "0n3pry1qmpq4basnny3gddls2zlwz0813ixnas87092rvlgjhbc6";
  };

  buildInputs = [qt4 ncurses];

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr/sbin" "$out/sbin"
  '';

  buildPhase = ''
    make
    cd GUI
    qmake
    make clean
    make
    cd ..
  '';

  installPhase = ''
    pwd
    ensureDir $out/sbin
    make install
    install -Dm755 GUI/i7z_GUI $out/sbin/i7z-gui
  '';

  meta = {
    description = "A better i7 (and now i3, i5) reporting tool for Linux";
    homepage = http://code.google.com/p/i7z;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
  };
}

