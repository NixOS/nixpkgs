{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "semver";
  version = "2.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20ffbb50248a6141bb9eba907db0e47ee4a239ddb55fe0ada8696fc241495a9d";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = https://github.com/k-bx/python-semver;
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
