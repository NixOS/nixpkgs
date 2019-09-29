{ stdenv, fetchFromGitHub, python, pyaes, pycrypto, uvloop, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "1i8v6w79ad3xn9dnn144q93vcs23cj0m7hj3x33i16hxz325zb9y";
  };

  nativeBuildInputs = [ wrapPython ];
  pythonPath = [ pyaes pycrypto uvloop ];

  installPhase = ''
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Async MTProto proxy for Telegram";
    license     = licenses.mit;
    homepage    = https://github.com/alexbers/mtprotoproxy;
    platforms   = python.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
