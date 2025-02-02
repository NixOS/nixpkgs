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
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    tag = "v${version}";
    hash = "sha256-aFN/cOSqsrTJ5GMw0/SM7uoC+T1RhDTQFf8AF00Tz/o=";
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
