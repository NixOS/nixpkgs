{stdenv, fetchurl, SDL}:

stdenv.mkDerivation rec { 
  name = "dosbox-0.72";
  
  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "0ydck7jgvdwnpxakg2y83dmk2dnwx146cgidbmdn7h75y7cxfiqp";
  };
  
  buildInputs = [SDL];
  
  # Add missing includes in order to fix compilation with glibc 2.9
  patchPhase = ''
    echo "#include <string.h>" > tmp.cpp
    for i in src/hardware/gameblaster.cpp src/hardware/tandy_sound.cpp
    do
      cat tmp.cpp $i > $i.new
      mv $i.new $i
    done
    echo "#include <stdlib.h>" > tmp.cpp
    cat tmp.cpp src/shell/shell_cmds.cpp > src/shell/shell_cmds.cpp.new
    mv src/shell/shell_cmds.cpp.new src/shell/shell_cmds.cpp
  '';

  meta = {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
  };
}
