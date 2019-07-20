{ stdenv, fetchFromGitHub, python, pyaes, pycrypto, wrapPython }:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "11jaz01cagmqadyxkks7dx41ggg6pp2l1ia9npqyrl2xhcxm5b0x";
  };

  nativeBuildInputs = [ wrapPython ];
  pythonPath = [ pyaes pycrypto ];

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
