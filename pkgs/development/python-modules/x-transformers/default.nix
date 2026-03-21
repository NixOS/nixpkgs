{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  einx,
  einops,
  loguru,
  packaging,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "x-transformers";
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "x-transformers";
    tag = version;
    hash = "sha256-6L6e0E6Yx5K+KOkkxJm6iF5Uxj6Tga4hTbkGy9MUtW4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    einx
    einops
    loguru
    packaging
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # RuntimeError: torch.compile is not supported on Python 3.14+
  disabledTests = lib.optionals (pythonAtLeast "3.14") [ "test_up" ];

  pythonImportsCheck = [ "x_transformers" ];

  meta = {
    description = "Concise but fully-featured transformer";
    longDescription = ''
      A simple but complete full-attention transformer with a set of promising experimental features from various papers.
    '';
    homepage = "https://github.com/lucidrains/x-transformers";
    changelog = "https://github.com/lucidrains/x-transformers/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
}
