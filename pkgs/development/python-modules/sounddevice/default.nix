{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, cffi
, numpy
, portaudio
, substituteAll
}:

buildPythonPackage rec {
  pname = "sounddevice";
  version = "0.4.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1667a7467b65fac4c4ebf668b4e9698eb7333fc3d32bc3c7ec9839ea7cb6c20";
  };

  propagatedBuildInputs = [ cffi numpy portaudio ];

  # No tests included nor upstream available.
  doCheck = false;

  pythonImportsCheck = [ "sounddevice" ];

  patches = [
    (substituteAll {
      src = ./fix-portaudio-library-path.patch;
      portaudio = "${portaudio}/lib/libportaudio.so.2";
    })
  ];

  meta = {
    description = "Play and Record Sound with Python";
    homepage = "http://python-sounddevice.rtfd.org/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
