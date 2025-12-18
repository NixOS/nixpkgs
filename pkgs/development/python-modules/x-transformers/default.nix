{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "2.11.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "x-transformers";
    tag = version;
    hash = "sha256-dS5i99WuGP/aDPXiNCDq2TmQ9T8RefX7pG5YINs6jHY=";
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
