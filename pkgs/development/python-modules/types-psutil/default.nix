{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "5.9.5.20240205";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ud82o2GqWXv0g9zFtY8qt6qHRSo20tqXyQmU1qge90M=";
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
