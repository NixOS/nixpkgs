{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  cffi,
  numpy,
  portaudio,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "sounddevice";
  version = "0.5.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jsn7/eLjLwILFn40jzqzusZiWl8Vr1JNeQEIrHFHpBA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
    homepage = "https://python-sounddevice.readthedocs.io/";
    changelog = "https://github.com/spatialaudio/python-sounddevice/releases/tag/${version}";
    license = lib.licenses.mit;
  };
}
