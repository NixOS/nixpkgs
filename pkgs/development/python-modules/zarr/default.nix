{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools-scm
, asciitree
, numpy
, fasteners
, numcodecs
, pytest
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.10.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ca8e505cadb4f7f97aab4e4193bb302b6338bf54593c98fe7581bf574ed864c";
  };

  nativeBuildInputs = [
    setuptools-scm
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
