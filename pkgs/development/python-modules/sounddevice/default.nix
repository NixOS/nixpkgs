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
  version = "0.5.2";
  pyproject = true;
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xjTVG9TpItbw+l4al1zIl8lH9h0x2p95un6jTf9Ei0k=";
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
