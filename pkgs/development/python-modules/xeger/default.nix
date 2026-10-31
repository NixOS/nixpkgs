{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xeger";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crdoconnor";
    repo = "xeger";
    tag = version;
    hash = "sha256-XujytGzBwJ59C5VihuFUJUxqhyjOIU4sI60hXUqLQvM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "xeger" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library to generate random strings from regular expressions";
    homepage = "https://github.com/crdoconnor/xeger";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
