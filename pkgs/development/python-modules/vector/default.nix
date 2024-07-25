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
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fa74kRVg2x6j/6nb1UFNDsV1pQSiw/I+pFFwoYmURm4=";
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
