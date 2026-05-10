{
  lib,
  buildPythonPackage,
  fetchPypi,
  inflection,
  requests,
}:

buildPythonPackage rec {
  pname = "sleepyq";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bhzrxpzglfw4qbqfzyxr7dmmavzq4pq0h90jh0aa8vdw7iy7g7v";
  };

  propagatedBuildInputs = [
    inflection
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "sleepyq" ];

  meta = {
    description = "Python module for SleepIQ API";
    homepage = "https://github.com/technicalpickles/sleepyq";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
