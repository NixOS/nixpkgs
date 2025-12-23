{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "typing-utils";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bojiang";
    repo = "typing_utils";
    tag = "v${version}";
    hash = "sha256-eXVGpe1wCH1JG+7ZP0evlxhw189GrrRzTwNDCALn3JI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "typing_utils" ];

  meta = {
    description = "Utils to inspect Python type annotations";
    homepage = "https://github.com/bojiang/typing_utils";
    changelog = "https://github.com/bojiang/typing_utils/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wulpine ];
  };
}
