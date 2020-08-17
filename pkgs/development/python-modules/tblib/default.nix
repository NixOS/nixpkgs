{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b48bx1h720rmmd9nmw50y5cq9vhdppnl0bn9yfl2yza0rrxg6q5";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
