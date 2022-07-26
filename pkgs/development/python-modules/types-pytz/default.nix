{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2022.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GoslwiXF5r2EaKqetF3dOzN/ZxbUByrQqk7x5BR47rw=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "pytz-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
