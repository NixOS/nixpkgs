{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  marisa-trie,
  platformdirs,
  pytest,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplemma";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    tag = "v${version}";
    hash = "sha256-VT6+wjyrHLquccnZpDTow7omDqeqlfbrdW3fozo/biU=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    marisa-trie = [
      marisa-trie
      platformdirs
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "simplemma" ];

  meta = {
    description = "Simple multilingual lemmatizer for Python, especially useful for speed and efficiency";
    homepage = "https://github.com/adbar/simplemma";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
