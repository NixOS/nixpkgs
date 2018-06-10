{ stdenv, fetchFromGitHub, avrbinutils, avrgcc, avrlibc, libelf, which, git, pkgconfig, freeglut
, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "simavr-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "e0d4de41a72520491a4076b3ed87beb997a395c0";
    sha256 = "0b2lh6l2niv80dmbm9xkamvnivkbmqw6v97sy29afalrwfxylxla";
  };

  # ld: cannot find -lsimavr
  enableParallelBuilding = false;

  preConfigure = ''
    substituteInPlace Makefile.common --replace "-I../simavr/sim/avr -I../../simavr/sim/avr" \
    "-I${avrlibc}/avr/include -L${avrlibc}/avr/lib/avr5  -B${avrlibc}/avr/lib -I../simavr/sim/avr -I../../simavr/sim/avr"
  '';
  buildFlags = "AVR_ROOT=${avrlibc}/avr SIMAVR_VERSION=${version}";
  installFlags = buildFlags + " DESTDIR=$(out)";

  
  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  postFixup = ''
    target="$out/bin/simavr"
    patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which git avrbinutils avrgcc avrlibc libelf freeglut libGLU_combined ];

  meta = with stdenv.lib; {
    description = "A lean and mean Atmel AVR simulator";
    homepage    = https://github.com/buserror/simavr;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ goodrone ];
  };

}

