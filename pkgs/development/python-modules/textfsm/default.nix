{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textfsm";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "textfsm";
    tag = "v${version}";
    hash = "sha256-ygVcDdT85mRN+qYfTZqraRVyp2JlLwwujBW1e/pPJNc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/google/textfsm/releases/tag/${src.tag}";
    description = "Python module for parsing semi-structured text into python tables";
    mainProgram = "textfsm";
    homepage = "https://github.com/google/textfsm";
<<<<<<< HEAD
    license = lib.licenses.asl20;
=======
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
