{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unrar-${version}";
  version = "5.4.5";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0v3rz2245bp2nh4115ysqv34vqlrpln9y11fnlzqj8i46f2caw74";
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
