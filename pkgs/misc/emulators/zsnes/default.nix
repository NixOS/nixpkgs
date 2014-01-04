{stdenv, fetchurl, nasm, SDL, zlib, libpng, ncurses, mesa}:

stdenv.mkDerivation {
  name = "zsnes-1.51";

  src = fetchurl {
    url = mirror://sourceforge/zsnes/zsnes151src.tar.bz2;
    sha256 = "08s64qsxziv538vmfv38fg1rfrz5k95dss5zdkbfxsbjlbdxwmi8";
  };

  # copied from arch linux, fixes gcc-4.8 compatibility
  patches = [ ./zsnes.patch ];

  postPatch = ''
    patch -p0 < ${./zsnes-1.51-libpng15.patch}
  '';

  buildInputs = [ nasm SDL zlib libpng ncurses mesa ];

  preConfigure = ''
    cd src

    sed -i "/^STRIP/d" configure
    
    # Fix for undefined strncasecmp()
    echo '#include <strings.h>' > tmp.cpp 
    cat tmp.cpp tools/strutil.h > tools/strutil.h.new
    mv tools/strutil.h.new tools/strutil.h
    
    # Fix for undefined system()
    echo '#include <stdlib.h>' > tmp.cpp
    cat tmp.cpp tools/depbuild.cpp > tools/depbuild.cpp.new
    mv tools/depbuild.cpp.new tools/depbuild.cpp
    
    # Fix for lots of undefined strcmp, strncmp etc.
    echo '#include <string.h>' > tmp.cpp 
    cat tmp.cpp parsegen.cpp > parsegen.cpp.new
    mv parsegen.cpp.new parsegen.cpp
  '';
  

  configureFlags = "--enable-release";

  meta = {
    description = "A Super Nintendo Entertainment System Emulator";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.sander ];
    homepage = http://www.zsnes.com;
  };
}
