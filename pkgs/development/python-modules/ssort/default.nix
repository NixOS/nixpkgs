{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pathspec,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "ssort";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    rev = "refs/tags/${version}";
    hash = "sha256-P/FUayCC7KfXjtzclTPLhLw5o0bV4L98tes69w+038o=";
  };

  build-system = [ setuptools ];

  dependencies = [ pathspec ];

  pythonImportsCheck = [ "ssort" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = {
    description = "Automatically sorting python statements within a module";
    homepage = "https://github.com/bwhmather/ssort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "ssort";
  };
}
