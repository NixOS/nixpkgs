{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  versioneer,
  pytestCheckHook,
  numpy,
  scipy,
  sympy,
}:

buildPythonPackage rec {
  pname = "transforms3d";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = "transforms3d";
    tag = version;
    hash = "sha256-9wICu7zNYF54e6xcDpZxqctB4GVu5Knf79Z36016Rpw=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    sympy
  ];

  pythonImportsCheck = [ "transforms3d" ];

  meta = {
    homepage = "https://matthew-brett.github.io/transforms3d";
    description = "Convert between various geometric transformations";
    changelog = "https://github.com/matthew-brett/transforms3d/blob/main/Changelog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
