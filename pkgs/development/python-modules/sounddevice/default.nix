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
  version = "0.4.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f690f5aa418a56268c7bdbc97d697c85add0134c5c79d44b8a2ad7a1b85da789";
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
