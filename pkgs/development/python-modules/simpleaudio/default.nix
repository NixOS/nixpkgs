{
  alsa-lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "simpleaudio";
  version = "1.0.4";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "hamiltron";
    repo = "py-simple-audio";
    rev = version;
    sha256 = "12nypzb1m14yip4zrbzin5jc5awyp1d5md5y40g5anj4phb4hx1i";
  };

  patches = [ ./python312-fix.patch ];

  buildInputs = [ alsa-lib ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/hamiltron/py-simple-audio";
    description = "Simple audio playback Python extension - cross-platform, asynchronous, dependency-free";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucus16 ];
=======
  meta = with lib; {
    homepage = "https://github.com/hamiltron/py-simple-audio";
    description = "Simple audio playback Python extension - cross-platform, asynchronous, dependency-free";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
