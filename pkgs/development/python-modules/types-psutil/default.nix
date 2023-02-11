{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "5.9.5.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tyb9sssGSydMvGNZ+6Sr87OimT19SrwzatCUdWghLGI=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "psutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
