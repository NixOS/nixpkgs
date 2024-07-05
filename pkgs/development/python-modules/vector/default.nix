{
  lib,
  awkward,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  numba,
  numpy,
  notebook,
  packaging,
  papermill,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "vector";
  version = "1.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GpQhDCGl04020Po2wa+5LChXuh0JyCSw1LhhXVH08uU=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    numpy
    packaging
  ];

  checkInputs = [
    awkward
    notebook
    numba
    papermill
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vector" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Library for 2D, 3D, and Lorentz vectors, especially arrays of vectors, to solve common physics problems in a NumPy-like way";
    homepage = "https://github.com/scikit-hep/vector";
    changelog = "https://github.com/scikit-hep/vector/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
