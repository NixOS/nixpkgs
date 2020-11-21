{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b31dfd9d8cba0271a5a447250bc07cdb5c3b1fd21b76b88a63dcd4bcdcb80769";
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
