{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "sortedl1";
    tag = "v${version}";
    hash = "sha256-8zDadGeHJNO0VLMIz2lDAsOUS+c1AB2wDoWDYcbLWVY=";
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
