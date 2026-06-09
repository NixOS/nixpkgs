{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  serialx,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ultraheat-api";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpathuis";
    repo = "ultraheat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mw2BEm98FqD/bggABJu8jftwyMEik0+xtKHONoFVxhw=";
  };

  build-system = [ setuptools ];

  dependencies = [ serialx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ultraheat_api" ];

  meta = {
    changelog = "https://github.com/vpathuis/ultraheat/releases/tag/${finalAttrs.src.tag}";
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
