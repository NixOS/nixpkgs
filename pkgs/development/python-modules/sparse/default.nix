{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, numpy
, scipy
, numba
, pytest
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.9.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gfwm1y9knryx992biniqa3978n3chr38iy3y4i2b8wy52fzy3d";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    numpy
    scipy
    numba
  ];

  checkPhase = ''
    pytest sparse
  '';

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://github.com/pydata/sparse/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
