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
  version = "0.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9b07cff59c837d258002ed806ee134ed367ef11042bd7d283d6ce407bf889c";
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
