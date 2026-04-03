{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stringparser";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "stringparser";
    tag = version;
    hash = "sha256-gj0ooeb869JhlB9Mf5nBydiV2thTes8ys+BLJ516iSA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stringparser" ];

  meta = {
    description = "Easy to use pattern matching and information extraction";
    homepage = "https://github.com/hgrecco/stringparser";
    changelog = "https://github.com/hgrecco/stringparser/blob/${version}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
