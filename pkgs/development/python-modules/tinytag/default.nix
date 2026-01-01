{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinytag";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinytag";
    repo = "tinytag";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-rvfObqAFcJwNpp9cUZv6QjffykajVR+Re1WUSdXkAvo=";
=======
    hash = "sha256-DyjFIaC7FwU5pvRfQgpBCc76dps287rcQ7mxggOZjdw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    flit-core
  ];

  pythonImportsCheck = [ "tinytag" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Read audio file metadata";
    homepage = "https://github.com/tinytag/tinytag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
