{ lib
, buildPythonPackage
, fetchPypi
, types-urllib3
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.27.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/ROC+i4o6shI+u2wMyhAIE8G8MtRcAjjx7goLKU+VtI=";
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
