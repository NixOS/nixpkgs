{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.6.43";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f62dbaf4739858148fe4889f3b4dff93da281982b6592f211c4d33c2e00678eb";
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
