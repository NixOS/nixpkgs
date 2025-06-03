{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  numpy,
  xarray,
  xarray-dataclasses,
}:

buildPythonPackage rec {
  pname = "spatial-image";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "spatial-image";
    repo = "spatial-image";
    tag = "v${version}";
    hash = "sha256-PGc2uey2xcfE0PcYDaCp7U0lgeGL1I6MMP3vbTN+Alk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    xarray
    xarray-dataclasses
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "spatial_image" ];

  meta = {
    description = "Multi-dimensional spatial image data structure for scientific Python";
    homepage = "https://github.com/spatial-image/spatial-image";
    changelog = "https://github.com/spatial-image/spatial-image/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
