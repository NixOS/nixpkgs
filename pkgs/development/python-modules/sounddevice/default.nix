{ lib
, buildPythonPackage
, fetchPypi
, cffi
, numpy
, portaudio
}:

buildPythonPackage rec {
  pname = "sounddevice";
  name = "${pname}-${version}";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9e833f8c8ccc67c0291c3448b29e9acc548fe56d15ee6f7fdd7037e00319f8";
  };

  propagatedBuildInputs = [ cffi numpy portaudio ];

  # No tests included nor upstream available.
  doCheck = false;

  prePatch = ''
    substituteInPlace src/sounddevice.py --replace "'portaudio'" "'${portaudio}/lib/libportaudio.so.2'"
  '';

  meta = {
    description = "Play and Record Sound with Python";
    homepage = http://python-sounddevice.rtfd.org/;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}