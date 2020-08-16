{ stdenv, buildPythonPackage, fetchPypi, pbr, setuptools, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38791aa5bed922b0a844513c5f9ed37774b68edc609e5ab8ab8d8fe0ce4315e5";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr setuptools six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
