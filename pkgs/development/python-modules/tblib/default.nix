{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "059bd77306ea7b419d4f76016aef6d7027cc8a0785579b5aad198803435f882c";
  };

  meta = with lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
