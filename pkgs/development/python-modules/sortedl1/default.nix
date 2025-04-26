{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pybind11,
  scikit-build-core,
  numpy,
  scikit-learn,
  scipy,
  cmake,
  ninja,
}:

buildPythonPackage rec {
  pname = "sortedl1";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s9sBgnEcXKr06hCFoEK+l0J817YF4FIE9hvMGNFQhpc=";
  };

  build-system = [
    pybind11
    scikit-build-core
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [
    "sortedl1"
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Sorted L-One Penalized Estimation";
    homepage = "https://jolars.github.io/sortedl1/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
