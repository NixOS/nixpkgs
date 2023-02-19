{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.19.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G2SyG2Cf8fx3kdPZMPFLVrNq0JAp/ZfkXjTMiJ1nG18=";
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
