{ lib
, buildPythonPackage
, fetchPypi
, cffi
, numpy
, portaudio
, substituteAll
}:

buildPythonPackage rec {
  pname = "sounddevice";
  version = "0.3.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7b0f7ad86550668da55404eabcb63d4212ec622fcce86510092306b77d2e80a";
  };

  propagatedBuildInputs = [ cffi numpy portaudio ];

  # No tests included nor upstream available.
  doCheck = false;

  patches = [
    (substituteAll {
      src = ./fix-portaudio-library-path.patch;
      portaudio = "${portaudio}/lib/libportaudio.so.2";
    })
  ];

  meta = {
    description = "Play and Record Sound with Python";
    homepage = http://python-sounddevice.rtfd.org/;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
