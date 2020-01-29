{ lib
, buildPythonPackage
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
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c62d0158fb287151c978904935a177b3d2d318dea3057cfbeac8541915dfa105";
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
    homepage = https://github.com/zarr-developers/zarr;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
