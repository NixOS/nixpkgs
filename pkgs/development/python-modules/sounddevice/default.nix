{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  setuptools,
  cffi,
  numpy,
  portaudio,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "sounddevice";
  version = "0.5.1";
  pyproject = true;
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CcqZHa7ajOS+mskeFamoHI+B76a2laNIyRceoMFssEE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cffi
    numpy
    portaudio
  ];

  nativeBuildInputs = [ cffi ];

  # No tests included nor upstream available.
  doCheck = false;

  pythonImportsCheck = [ "sounddevice" ];

  patches = [
    (replaceVars ./fix-portaudio-library-path.patch {
      portaudio = "${portaudio}/lib/libportaudio${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  meta = {
    description = "Play and Record Sound with Python";
    homepage = "http://python-sounddevice.rtfd.org/";
    license = with lib.licenses; [ mit ];
  };
}
