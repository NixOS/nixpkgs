{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  cython,
  tabulate,
}:

buildPythonPackage rec {
  pname = "youtokentome";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VKCOM";
    repo = "YouTokenToMe";
    tag = "v${version}";
    hash = "sha256-+GI752Ih7Ou1wyChR2y80BJmeTYdHWLPX6A1lvMyLGU=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    click
    tabulate
  ];

  pythonImportsCheck = [ "youtokentome" ];

  meta = {
    description = "Unsupervised text tokenizer";
    mainProgram = "yttm";
    homepage = "https://github.com/VKCOM/YouTokenToMe";
    changelog = "https://github.com/VKCOM/YouTokenToMe/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
