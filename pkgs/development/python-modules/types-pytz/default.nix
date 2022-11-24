{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2022.6.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0HgZY3TRJ36fmYTUk3PqBDzyxk1dXEkfvIbCWFV71G8=";
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
