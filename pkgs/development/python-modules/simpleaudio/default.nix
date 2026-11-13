{
  alsa-lib,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage rec {
  pname = "simpleaudio";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hamiltron";
    repo = "py-simple-audio";
    rev = version;
    hash = "sha256-MXRIFrxEWlUeIL60Wlq4nqvCZLHxr/zJjZ6EGta/3oo=";
  };

  patches = [ ./python312-fix.patch ];

  buildInputs = [ alsa-lib ];

  meta = {
    homepage = "https://github.com/hamiltron/py-simple-audio";
    description = "Simple audio playback Python extension - cross-platform, asynchronous, dependency-free";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucus16 ];
  };
}
