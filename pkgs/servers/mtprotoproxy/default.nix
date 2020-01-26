{ stdenv, fetchFromGitHub, python, pyaes, pycrypto, uvloop, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "16f9hzh4h41qb5962lxx04653ncar83znh872g2qh564b6f922z2";
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
