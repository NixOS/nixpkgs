{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "semver";
  version = "2.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6212f5c552452e306502ac8476bbca48af62db29c4528fdd91d319d0a44b07b";
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
