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
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bon1d6r18eayuqhhK8zAckFWGSilX3eUc213HSeO2dQ=";
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
