{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "195jx8q6rri8nl1fkhirlwvpv8ahrbnhrrprws5kw2phdnq3qy3b";
  };

  propagatedBuildInputs = [ numpy ];

  # tests are not included in pypi distributions and would require lots of
  # optional dependencies
  doCheck = false;

  meta = with lib; {
    description = "Python library for loading and using triangular meshes.";
    homepage = "https://trimsh.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
