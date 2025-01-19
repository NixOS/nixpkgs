{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "wordninja";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GhzH7BRq0Z1vcZQe6CrvPTEiFwDw2L+EQTbPjfedKBo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "wordninja"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/keredson/wordninja";
    description = "Probabilistically split concatenated words using NLP based on English Wikipedia unigram frequencies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
