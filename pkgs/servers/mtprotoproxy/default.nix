{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  pyaes,
  pycrypto,
  uvloop,
  wrapPython,
}:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "sha256-tQ6e1Y25V4qAqBvhhKdirSCYzeALfH+PhNtcHTuBurs=";
  };

  nativeBuildInputs = [ wrapPython ];
  pythonPath = [
    pyaes
    pycrypto
    uvloop
  ];

  installPhase = ''
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
    wrapPythonPrograms
  '';

  meta = {
    description = "Async MTProto proxy for Telegram";
    license = lib.licenses.mit;
    homepage = "https://github.com/alexbers/mtprotoproxy";
    platforms = python.meta.platforms;
    maintainers = with lib.maintainers; [ abbradar ];
    mainProgram = "mtprotoproxy";
  };
}
