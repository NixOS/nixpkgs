{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pathspec,
  pytestCheckHook,
  pyyaml,
  pythonAtLeast,
}:
buildPythonPackage rec {
  pname = "ssort";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    tag = version;
    hash = "sha256-7WeLhetqbqiQQlDmoWSMzydhiKcdI2CbemKjWJd5Uoc=";
  };

  disabled = pythonAtLeast "3.13"; # Python 3.13 has introduced new builtin functions. ssort 0.14 does not know how to correctly sort python>=3.13 source code.

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
