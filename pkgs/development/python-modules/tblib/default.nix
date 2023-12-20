{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pt8w8nLAi/i+ZuB3X62GIAXZUKa4RJuU98eIcx1w7Nc=";
  };

  meta = with lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
