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
  version = "2.5.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d54f060739208392494c3dbcbfdf41c8df9fa23d9a32b91aea0549b4c5e2b77f";
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
