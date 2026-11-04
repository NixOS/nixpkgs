{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wheezy.template";
  version = "3.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akornatskyy";
    repo = "wheezy.template";
    tag = finalAttrs.version;
    hash = "sha256-idSF+FosxuiE8KUTS0YIh2Pzer3ra7H6JV3bX5qQwM8=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  optional-dependencies.cython = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "wheezy.template" ];

  meta = {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    changelog = "https://github.com/akornatskyy/wheezy.template/releases/tag/${finalAttrs.src.tag}";
    description = "Lightweight template library";
    mainProgram = "wheezy.template";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
