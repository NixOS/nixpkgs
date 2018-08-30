{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "436e4200e63d92316551179dc540906652878df4ff39b43db30fcf6400444fe7";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = https://github.com/ionelmc/python-tblib;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
