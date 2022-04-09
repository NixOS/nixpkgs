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
  version = "2.11.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sIc74nr1aQc4+hWOp6gC6uRUkEwzmVBWGFrMWnQltFE=";
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
