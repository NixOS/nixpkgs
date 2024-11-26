{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  numpy,
  xarray,
  xarray-dataclasses,
}:

buildPythonPackage rec {
  pname = "spatial-image";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spatial-image";
    repo = "spatial-image";
    rev = "refs/tags/v${version}";
    hash = "sha256-yIAqHhq2naTA8PdLOdrNSrhEOhRwlFD6x9dH4xDVt9Y=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    numpy
    xarray
    xarray-dataclasses
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "spatial_image" ];

  meta = with lib; {
    description = "Multi-dimensional spatial image data structure for scientific Python";
    homepage = "https://github.com/spatial-image/spatial-image";
    changelog = "https://github.com/spatial-image/spatial-image/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
