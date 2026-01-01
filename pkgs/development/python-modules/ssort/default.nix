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
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bwhmather";
    repo = "ssort";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-QVodBJsYryVue0QXaZbjo1JtwuCBUiuZ+XU+I7jJCq8=";
=======
    hash = "sha256-7WeLhetqbqiQQlDmoWSMzydhiKcdI2CbemKjWJd5Uoc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
