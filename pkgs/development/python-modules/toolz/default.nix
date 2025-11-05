{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-git-versioning,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J6XHcNBowRDZ7ZMj8k8VQ+g7LzAKaHt4kcGm1Wtpe1s=";
  };

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    changelog = "https://github.com/pytoolz/toolz/releases/tag/${version}";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
  };
}
