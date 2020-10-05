{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a47921f07822fe534fb1c01c9931ab335a4390c782bd28c6bcc7c2f71f3fbf";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    # https://github.com/pytoolz/toolz/issues/357
    rm toolz/tests/test_serialization.py
    nosetests toolz/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
