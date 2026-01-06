{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  numpy,
  xarray,
  xarray-dataclass,
}:

buildPythonPackage rec {
  pname = "spatial-image";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "spatial-image";
    repo = "spatial-image";
    tag = "v${version}";
    hash = "sha256-mhT86v4/5s4dFw9sDYm5Ba7sM0ME9ifN9KEzhxVigOc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    xarray
    xarray-dataclass
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
