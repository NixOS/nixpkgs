{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unrar-${version}";
  version = "5.3.11";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0qw77gvr57azjbn76cjlm4sv1hf2hh90g7n7n33gfvlpnbs7mf3p";
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
    installBin unrar

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
