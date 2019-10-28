{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1735ff8fd6217446384b5afabead3b142cf1a52d242cfe6cab4240029d6d131a";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = https://github.com/ionelmc/python-tblib;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
