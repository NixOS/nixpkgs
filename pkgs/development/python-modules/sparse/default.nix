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
  version = "0.8.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3dc14ee5314caa2e64331b0b50c8f92e8999d7d275179a804a114e6cb1f8b81";
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
    homepage = https://github.com/pydata/sparse/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    broken = true;
  };
}
