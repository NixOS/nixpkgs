{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "semver";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "161gvsfpw0l8lnf1v19rvqc8b9f8n70cc8ppya4l0n6rwc1c1n4m";
  };

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = https://github.com/k-bx/python-semver;
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
