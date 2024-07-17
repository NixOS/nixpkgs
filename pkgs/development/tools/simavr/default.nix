{
  lib,
  stdenv,
  makeSetupHook,
  fetchFromGitHub,
  libelf,
  which,
  pkg-config,
  libglut,
  avrgcc,
  avrlibc,
  libGLU,
  libGL,
  GLUT,
}:

let
  setupHookDarwin = makeSetupHook {
    name = "darwin-avr-gcc-hook";
    substitutions = {
      darwinSuffixSalt = stdenv.cc.suffixSalt;
      avrSuffixSalt = avrgcc.suffixSalt;
    };
  } ./setup-hook-darwin.sh;
in
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

  nativeBuildInputs = [
    which
    pkg-config
    avrgcc
  ] ++ lib.optional stdenv.isDarwin setupHookDarwin;
  buildInputs = [
    libelf
    libglut
    libGLU
    libGL
  ] ++ lib.optional stdenv.isDarwin GLUT;

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out"/bin/*
  '';

  doCheck = true;
  checkTarget = "-C tests run_tests";

  meta = with lib; {
    description = "Lean and mean Atmel AVR simulator";
    mainProgram = "simavr";
    homepage = "https://github.com/buserror/simavr";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ goodrone ];
  };

}
