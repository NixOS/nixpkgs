{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2021.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6d21d6687935a1615db464b1e1df800d19502c36bc0486f43be7dfd2c404947";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pytz-stubs" ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
