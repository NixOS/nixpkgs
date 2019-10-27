{ stdenv, buildPythonPackage, fetchPypi, pbr, setuptools, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "054apq55yg7058pmbnyc8jhrcpi9clmi0sm7znhwg0d676brywz0";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr setuptools six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
