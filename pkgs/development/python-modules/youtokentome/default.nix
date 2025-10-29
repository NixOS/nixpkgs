{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  cython,
  pythonOlder,
  tabulate,
}:

buildPythonPackage rec {
  pname = "youtokentome";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Unsupervised text tokenizer";
    mainProgram = "yttm";
    homepage = "https://github.com/VKCOM/YouTokenToMe";
    changelog = "https://github.com/VKCOM/YouTokenToMe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
