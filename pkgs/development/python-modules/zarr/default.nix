{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools_scm
, asciitree
, numpy
, fasteners
, numcodecs
, pytest
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.6.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa7eac1e4ff47ff82d09c42bb4679e18e8a05a73ee81ce59cee6a441a210b2fd";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    asciitree
    numpy
    fasteners
    numcodecs
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "An implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
