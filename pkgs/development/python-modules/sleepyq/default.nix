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
    hash = "sha256-+7zj4+FtI6UAlCBBgC/Bf6ta28ndf4cXJtzR92/PH64=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
