{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nVVvyvaAihzq1KqkHlwHph8BUqh1gR4SOXOOuk4LexY=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
