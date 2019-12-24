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
  version = "0.7.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ija4pl8wg36ldsdv5jmqr5i75qi17vijcwwf2jdn1k15kqg35j4";
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
