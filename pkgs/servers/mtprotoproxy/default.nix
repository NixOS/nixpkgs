{ stdenv, fetchFromGitHub, python, pyaes, pycrypto, uvloop, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "1j8bxwcq968h5sd58g03yc4zjqkhkjdn0f04vr826hhsdxy853r4";
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
