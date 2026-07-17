{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  # dependencies
  colorama,
  termcolor,
}:

buildPythonPackage (finalAttrs: {
  pname = "udapi";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "udapi";
    repo = "udapi-python";
    tag = finalAttrs.version;
    hash = "sha256-0h4nfd3QHdZNiT0VFBs6xJ/lpiNPzcJQmV60KoH0Nv0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "udapi" ];

  meta = {
    description = "Python framework for processing Universal Dependencies data";
    homepage = "https://github.com/udapi/udapi-python";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/udapi/udapi-python/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      Stebalien
    ];
  };
})
