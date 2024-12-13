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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    rev = "refs/tags/${version}";
    hash = "sha256-TINktjuTdyRYkqIs3Jyv6vobSBqV1iPoHrG36sBHah8=";
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
