{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec{
  pname = "toolz";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "929f0a7ea7f61c178bd951bdae93920515d3fbdbafc8e6caf82d752b9b3b31c9";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    # https://github.com/pytoolz/toolz/issues/357
    rm toolz/tests/test_serialization.py
    nosetests toolz/tests
  '';

  meta = {
    homepage = https://github.com/pytoolz/toolz/;
    description = "List processing tools and functional utilities";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
