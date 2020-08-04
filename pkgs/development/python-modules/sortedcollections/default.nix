{ stdenv
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sihzm5aqz7r3irh4jn6rzicb7lf81d27z7vl6kaslnhwcsizhsq";
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
