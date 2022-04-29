{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
, enum34
, attrs
, pytz
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10b34e7f8e3207ee6fb70dcdc9bce473851ee3daf0b47c58aec1b48032ac11ce";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ enum34 ];

  checkInputs = [ attrs pytz ];
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "A simple serialization library based on ast.literal_eval";
    homepage = "https://github.com/irmen/Serpent";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
