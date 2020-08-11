{ stdenv, buildPythonPackage, fetchPypi, pbr, setuptools, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "609912b87df5ad338ff8e44d13eaad4f4170a65b79ae9cb0aa5632598994a1b7";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr setuptools six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
