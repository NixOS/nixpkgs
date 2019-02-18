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
  version = "0.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f59ae4e2ec12cb1e5940f06f08804ecca855d959de25ca45a3938de45d0f81a2";
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