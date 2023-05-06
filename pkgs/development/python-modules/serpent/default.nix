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
  version = "1.41";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BAcDX+PGZEOH1Iz/FGfVqp/v+BTQc3K3hnftDuPtcJU=";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ enum34 ];

  nativeCheckInputs = [ attrs pytz ];
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
