{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.18.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oO+DHcIGNfNQ+pz/WRIxwx0n51dx5Z/WyXm2wMfgMpI=";
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
