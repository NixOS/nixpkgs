{stdenv, fetchurl, zlib, libpng, SDL, nasm}:

stdenv.mkDerivation {
  name = "VisualBoyAdvance-1.7.2";
  src = fetchurl {
    url = mirror://sourceforge/vba/VisualBoyAdvance-src-1.7.2.tar.gz;
    sha256 = "1dr9w5i296dyq2gbx7sijk6p375aqnwld2n6rwnbzm2g3a94y4gl";
  };
  patches = [ ./libpng15.patch ./fix.diff ./timing.patch ];
  preConfigure = ''
    # Fix errors with invalid conversion from 'const char*' to 'char*'
    sed -i -e "s|char \* p = strrchr|const char * p = strrchr|g" src/GBA.cpp
    sed -i -e "s|char \* p = strrchr|const char * p = strrchr|g;s|([*])(void [*],|(*)(gzFile,|" src/Util.cpp
    sed -i -e "s|for[(]int i = 0; i < 16; i++[)] [{]|for(int z = 0; z < 16; z++) {|" src/sdl/debugger.cpp
  '';
  buildInputs = [ zlib libpng SDL ] ++ stdenv.lib.optional (stdenv.system == "i686-linux") nasm;

  meta = {
    description = "A Game Boy/Game Boy Color/Game Boy Advance Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    homepage = http://vba.ngemu.com;
  };
}
