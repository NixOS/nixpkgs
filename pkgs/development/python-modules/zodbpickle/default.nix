{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uewy5wbHuAi3mlOnrZZgkRfpQoN3K0AO52VSEHqrzBE=";
  };

  # fails..
  doCheck = false;

  pythonImportsCheck = [
    "zodbpickle"
  ];

  meta = with lib; {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
