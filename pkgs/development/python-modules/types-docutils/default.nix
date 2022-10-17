{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.19.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ffEzuHEFr0EPxqmSAwpw7p9aLCY2xa/n4N4oXrn9sBU=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "docutils-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for docutils";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
