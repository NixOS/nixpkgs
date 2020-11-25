{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.8.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dba3d9fa1d9488053fc7504c141fbb2258cf5f37377a3824b20bd0a93f7240a0";
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
