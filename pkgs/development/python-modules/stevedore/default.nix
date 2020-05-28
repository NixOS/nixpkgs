{ stdenv, buildPythonPackage, fetchPypi, pbr, setuptools, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02shnm8r8c0bv494m8sjnrrlqy0pz5q5xrzpq069bx9sc8fszbqq";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr setuptools six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
