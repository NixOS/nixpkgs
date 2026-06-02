{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  numpy,
  typing-extensions,
  xarray,
}:

buildPythonPackage rec {
  pname = "xarray-dataclasses";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropenguin";
    repo = "xarray-dataclasses";
    tag = "v${version}";
    hash = "sha256-p9xV9Mpk5fsWR8X6VWNaeRi66OqK4QQWA8pwD2aYqOU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "xarray" ];

  propagatedBuildInputs = [
    numpy
    typing-extensions
    xarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xarray_dataclasses" ];

  meta = {
    description = "Xarray data creation made easy by dataclass";
    homepage = "https://github.com/astropenguin/xarray-dataclasses";
    changelog = "https://github.com/astropenguin/xarray-dataclasses/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
