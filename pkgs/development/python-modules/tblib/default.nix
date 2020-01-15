{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k9vmw0kcbkij9lbz80imkwkhq24vgrqf1i95kv8y5aaarjda6mx";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = https://github.com/ionelmc/python-tblib;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
