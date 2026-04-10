{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ukkonen";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "ukkonen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vXyOLAiY92Df7g57quiSnOz8yhaIsm8MTB6Fbiv6axQ=";
  };

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ukkonen" ];

  meta = {
    description = "Python implementation of bounded Levenshtein distance (Ukkonen)";
    homepage = "https://github.com/asottile/ukkonen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
