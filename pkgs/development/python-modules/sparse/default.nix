{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, numba
, pytest
, pytestcov
, pytest-flake8
, isPy27
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.8.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = pname;
    rev = version;
    sha256 = "0mhzmzi8z1f0clvrpm7adx3q414jp329ixczks0wkxamsg8plx5y";
  };

  checkInputs = [
    pytest
    pytestcov
    pytest-flake8
  ];

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
  };
}
