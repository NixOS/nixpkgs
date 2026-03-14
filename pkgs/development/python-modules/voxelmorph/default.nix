{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  neurite,
  scikit-image,
  torch,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "voxelmorph";
  version = "0.3-unstable-2025-12-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "voxelmorph";
    repo = "voxelmorph";
    rev = "b5cf28f89e2e45bbe2b6071668ac77e95c998b81";
    hash = "sha256-UnLwprsJxkdeeZsgs2UEdCZB6+hJc/GEo+ZPZ8HDISs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    neurite
    scikit-image
    torch
  ];

  pythonImportsCheck = [ "voxelmorph" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Unsupervised learning for image registration";
    homepage = "https://github.com/voxelmorph/voxelmorph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
