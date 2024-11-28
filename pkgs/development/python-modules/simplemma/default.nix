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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    rev = "refs/tags/v${version}";
    hash = "sha256-X0mqFPdCo0/sTexv4bi4bND7LFHOJvlOPH6tB39ybZY=";
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
