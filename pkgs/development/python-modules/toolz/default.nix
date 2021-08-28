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
    sha256 = "1grz3zvw5ixwqqlbv0n7j11mlcxb66cirh5i9x9zw8kqy0hpk967";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests toolz/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
