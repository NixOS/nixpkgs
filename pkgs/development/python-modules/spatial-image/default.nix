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
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "spatial-image";
    repo = "spatial-image";
    tag = "v${version}";
    hash = "sha256-Frvr8uJ3dD2lZFfqrNnki+JUbjhBdRK3BBAtIRtFqvs=";
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
    changelog = "https://github.com/spatial-image/spatial-image/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
