{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-docopt";
  version = "0.6.11.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mRpkwVaTEMIkCuc0/SwQYnq7ikr6875axvTv+aYB8xo=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "docopt-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for docopt";
    homepage = "https://pypi.org/project/types-docopt/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
