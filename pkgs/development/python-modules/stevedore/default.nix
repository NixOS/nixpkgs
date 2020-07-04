{ stdenv, buildPythonPackage, fetchPypi, pbr, setuptools, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "001e90cd704be6470d46cc9076434e2d0d566c1379187e7013eb296d3a6032d9";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr setuptools six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
