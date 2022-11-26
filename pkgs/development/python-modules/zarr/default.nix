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
  version = "2.12.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UVox7kuta7SK4FF4xYiuSaAqNd76Ad2aMpMwaQM2gWU=";
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
    description = "Implementation of chunked, compressed, N-dimensional arrays";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers: [ costrouc ];
  };
}
