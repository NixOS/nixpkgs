{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "semver";
  version = "2.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ffb55fb86a076cf7c161e6b5931f7da59f15abe217e0f24cea96cc8eec50f42";
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
