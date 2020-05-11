{ lib
, fetchPypi
, buildPythonPackage
, numpy
}:

buildPythonPackage rec {
  pname = "wavio";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j2zfzlh1q3kpqpywh74fn24vgzzz6mjaz2k9lv73hz2c1gg1n36";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = with lib; {
    description = "A Python module for reading and writing WAV files using numpy arrays";
    homepage = "https://github.com/WarrenWeckesser/wavio";
    maintainers = with maintainers; [ timokau ];
    license = licenses.bsd2;
  };
}
