{ stdenv
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12nkw69lnyvh9wy6rsd0ng4bcia81vkhj1rj1kj1k3vzppn0sgmr";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  # No tests in PyPi tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Sorted Collections";
    homepage = http://www.grantjenks.com/docs/sortedcollections/;
    license = licenses.asl20;
  };

}
