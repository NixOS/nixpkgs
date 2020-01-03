{ stdenv, fetchFromGitHub, libelf, which, pkgconfig, freeglut
, avrgcc, avrlibc
, libGLU, libGL
, GLUT }:

stdenv.mkDerivation rec {
  pname = "simavr";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "e0d4de41a72520491a4076b3ed87beb997a395c0";
    sha256 = "0b2lh6l2niv80dmbm9xkamvnivkbmqw6v97sy29afalrwfxylxla";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "AVR_ROOT=${avrlibc}/avr"
    "SIMAVR_VERSION=${version}"
    "AVR=avr-"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  nativeBuildInputs = [ which pkgconfig avrgcc ];
  buildInputs = [ libelf freeglut libGLU libGL ]
    ++ stdenv.lib.optional stdenv.isDarwin GLUT;

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  doCheck = true;
  checkTarget = "-C tests run_tests";

  meta = with stdenv.lib; {
    description = "A lean and mean Atmel AVR simulator";
    homepage    = https://github.com/buserror/simavr;
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ goodrone ];
  };

}
