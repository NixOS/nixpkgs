{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  cffi,
  numpy,
  portaudio,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "sounddevice";
  version = "0.4.7";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-abOGgY1QotUYYH1LlzRC6NUkdgx81si4vgPYyY/EvOc=";
  };

  propagatedBuildInputs = [
    cffi
    numpy
    portaudio
  ];

  # No tests included nor upstream available.
  doCheck = false;

  pythonImportsCheck = [ "sounddevice" ];

  patches = [
    (substituteAll {
      src = ./fix-portaudio-library-path.patch;
      portaudio = "${portaudio}/lib/libportaudio${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  meta = {
    description = "Play and Record Sound with Python";
    homepage = "http://python-sounddevice.rtfd.org/";
    license = with lib.licenses; [ mit ];
  };
}
