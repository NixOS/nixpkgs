{ stdenv, fetchFromGitHub, python, pyaes, pycrypto, uvloop, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "1bpgbqbgy7c637bzm6g5msm2i10dfl4qb7psy3k3cbaysw696kjc";
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
