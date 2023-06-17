{ lib, stdenv, makeSetupHook, fetchFromGitHub, libelf, which, pkg-config, freeglut
, avrgcc, avrlibc
, libGLU, libGL
, GLUT }:

let
  setupHookDarwin = makeSetupHook {
    name = "darwin-avr-gcc-hook";
    substitutions = {
      darwinSuffixSalt = stdenv.cc.suffixSalt;
      avrSuffixSalt = avrgcc.suffixSalt;
    };
  } ./setup-hook-darwin.sh;
in stdenv.mkDerivation rec {
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

  nativeBuildInputs = [ which pkg-config avrgcc ]
    ++ lib.optional stdenv.isDarwin setupHookDarwin;
  buildInputs = [ libelf freeglut libGLU libGL ]
    ++ lib.optional stdenv.isDarwin GLUT;

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  doCheck = true;
  checkTarget = "-C tests run_tests";

  meta = with lib; {
    description = "A lean and mean Atmel AVR simulator";
    homepage    = "https://github.com/buserror/simavr";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ goodrone ];
  };

}
