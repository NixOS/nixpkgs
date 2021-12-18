{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.26.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e22d9cdeff4c3eb068eb883d59b127c98d80525f3d0412a1c4499c6ae1f711e";
  };

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
