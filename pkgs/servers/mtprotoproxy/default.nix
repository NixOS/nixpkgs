{ lib, stdenv, fetchFromGitHub, python, pyaes, pycrypto, uvloop, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "15svvramxzl8q8xzs8g62gg8czdn46fjy6jhs5hqf5p83ycxsygz";
  };

  nativeBuildInputs = [ wrapPython ];
  pythonPath = [ pyaes pycrypto uvloop ];

  installPhase = ''
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Async MTProto proxy for Telegram";
    license     = licenses.mit;
    homepage    = "https://github.com/alexbers/mtprotoproxy";
    platforms   = python.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
