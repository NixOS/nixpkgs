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
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    tag = version;
    hash = "sha256-QVodBJsYryVue0QXaZbjo1JtwuCBUiuZ+XU+I7jJCq8=";
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
