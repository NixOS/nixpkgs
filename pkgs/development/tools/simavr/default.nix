{ lib, stdenv, fetchFromGitHub, libelf, which, pkg-config, freeglut
, avrgcc, avrlibc
, libGLU, libGL
, GLUT }:

stdenv.mkDerivation rec {
  pname = "simavr";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "v${version}";
    sha256 = "0njz03lkw5374x1lxrq08irz4b86lzj2hibx46ssp7zv712pq55q";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "AVR_ROOT=${avrlibc}/avr"
    "SIMAVR_VERSION=${version}"
    "AVR=avr-"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  nativeBuildInputs = [ which pkg-config avrgcc ];
  buildInputs = [ libelf freeglut libGLU libGL ]
    ++ lib.optional stdenv.isDarwin GLUT;

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  doCheck = true;
  checkTarget = "-C tests run_tests";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A lean and mean Atmel AVR simulator";
    homepage    = "https://github.com/buserror/simavr";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ goodrone ];
  };

}
