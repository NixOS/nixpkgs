{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  pytestCheckHook,
  numpy,
  typing-extensions,
  xarray,
}:

buildPythonPackage rec {
  pname = "xarray-dataclass";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "xarray-dataclass";
    tag = "v${version}";
    hash = "sha256-NHJvrkoRhq5cPSBBMWzrWVn+3sPvveMRgTXc/NdLfuA=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [ "xarray" ];

  dependencies = [
    numpy
    typing-extensions
    xarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xarray_dataclass" ];

  meta = with lib; {
    description = "Xarray data creation made easy by dataclass";
    homepage = "https://xarray-contrib.github.io/xarray-dataclass";
    changelog = "https://github.com/xarray-contrib/xarray-dataclass/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
