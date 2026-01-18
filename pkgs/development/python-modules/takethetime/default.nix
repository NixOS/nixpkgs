{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "takethetime";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "TakeTheTime";
    inherit version;
    hash = "sha256-2+MEU6G1lqOPni4/qOGtxa8tv2RsoIN61cIFmhb+L/k=";
  };

  # all tests are timing dependent
  doCheck = false;

  pythonImportsCheck = [ "takethetime" ];

  meta = {
    description = "Simple time taking library using context managers";
    homepage = "https://github.com/ErikBjare/TakeTheTime";
    maintainers = with lib.maintainers; [ huantian ];
    license = lib.licenses.mit;
  };
}
