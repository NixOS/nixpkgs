{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "semver-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://pypi/s/semver/${name}.tar.gz";
    sha256 = "161gvsfpw0l8lnf1v19rvqc8b9f8n70cc8ppya4l0n6rwc1c1n4m";
  };

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = "https://github.com/k-bx/python-semver";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
