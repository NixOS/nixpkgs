{ lib
, buildPythonPackage
, fetchPypi
, types-urllib3
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.28.11.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-p983zG+2GHqECX2pUfjiHTNUSKolAaawo5y9HXyp7io=";
  };

  propagatedBuildInputs = [
    types-urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "requests-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
