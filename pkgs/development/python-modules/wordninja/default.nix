{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
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
    wheel
  ];

  pythonImportsCheck = [ "wordninja" ];

  meta = {
    description = "Probabilistically split concatenated words using NLP based on English Wikipedia unigram frequencies";
    homepage = "https://github.com/keredson/wordninja";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
