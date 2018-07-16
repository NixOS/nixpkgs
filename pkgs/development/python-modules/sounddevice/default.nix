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
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pfcbgbl77nggchxb2i5rb78m7hpgn65aqpz99yfx1fgfbmy9yg1";
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