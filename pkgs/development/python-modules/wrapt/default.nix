{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
}:

buildPythonPackage (finalAttrs: {
  pname = "wrapt";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "wrapt";
    tag = finalAttrs.version;
    hash = "sha256-D32aQa7E1oW17XYOzSn7acKF2RY3qnG3sxrxtkrWi+8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wrapt" ];

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    changelog = "https://github.com/GrahamDumpleton/wrapt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
