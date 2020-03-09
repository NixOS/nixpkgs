{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "229bee3754cb5d98b4837dd5c4405e80cfab57cb9f93220410ad367f8b352344";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = https://github.com/ionelmc/python-tblib;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
