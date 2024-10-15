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
  version = "0.5.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DelSd2VLPUA9nBXe08bO3zB+myfMnOe9mVookdDJVa8=";
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
