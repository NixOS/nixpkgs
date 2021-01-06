{ stdenv
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i9cvwz4gikkp5jmk0bzsbyisnwy4sfazm9bg7b8q9j266plr4rl";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  # No tests in PyPi tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Sorted Collections";
    homepage = "http://www.grantjenks.com/docs/sortedcollections/";
    license = licenses.asl20;
  };

}
