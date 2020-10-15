{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.8.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "790b4804227825a985189e0788cf57dbfcf1ee39f30f767176722ad572da27de";
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
