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
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc5ec8534c3831ab133c497721f3aaeed4f5084b0eda842f0c0ada09f2f066dc";
  };

  propagatedBuildInputs = [ cffi numpy portaudio ];

  # No tests included nor upstream available.
  doCheck = false;

  prePatch = ''
    substituteInPlace sounddevice.py --replace "'portaudio'" "'${portaudio}/lib/libportaudio.so.2'"
  '';

  meta = {
    description = "Play and Record Sound with Python";
    homepage = http://python-sounddevice.rtfd.org/;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}