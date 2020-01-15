{ stdenv, buildPythonPackage, fetchPypi, pbr, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.30.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1860zslirsqskc2iifljxcyly28zqgjpmkm7k3bj6zyqagzriq3v";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
