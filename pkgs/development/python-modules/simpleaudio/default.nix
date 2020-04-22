{ alsaLib, buildPythonPackage, fetchFromGitHub, isPy27, lib }:

buildPythonPackage rec {
  pname = "simpleaudio";
  version = "1.0.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "hamiltron";
    repo = "py-simple-audio";
    rev = version;
    sha256 = "12nypzb1m14yip4zrbzin5jc5awyp1d5md5y40g5anj4phb4hx1i";
  };

  buildInputs = [ alsaLib ];

  meta = with lib; {
    homepage = "https://github.com/hamiltron/py-simple-audio";
    description =
      "A simple audio playback Python extension - cross-platform, asynchronous, dependency-free";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
