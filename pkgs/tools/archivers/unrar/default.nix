{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unrar-${version}";
  version = "5.5.5";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "1vv1s1pa0pf1r0h7dw89ha9y68x7hdm82csnkh6ms0igrcwkhmd4";
  };

  postPatch = ''
    sed 's/^CXX=g++/#CXX/' -i makefile
  '';

  buildPhase = ''
    make unrar
    make clean
    make lib
  '';

  installPhase = ''
    install -Dt "$out/bin" unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar

    install -Dm755 libunrar.so $out/lib/libunrar.so
    install -D dll.hpp $out/include/unrar/dll.hpp
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Utility for RAR archives";
    homepage = http://www.rarlab.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
