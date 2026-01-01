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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Unsupervised text tokenizer";
    mainProgram = "yttm";
    homepage = "https://github.com/VKCOM/YouTokenToMe";
    changelog = "https://github.com/VKCOM/YouTokenToMe/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
