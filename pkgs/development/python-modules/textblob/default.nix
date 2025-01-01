{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  flit-core,
  nltk,
}:

buildPythonPackage rec {
  pname = "textblob";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-61B7Yr8ig6cfVr7T4PxO7H04jvdrA2mc+ZQWZXKo2vM=";
  };

  build-system = [ flit-core ];

  dependencies = [ nltk ];

  pythonImportsCheck = [ "textblob" ];

  # Test process requires network access to download wordnet
  # Error: 'wordnet not found' 'Attempted to load corpora/wordnet'
  # nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/sloria/TextBlob/releases/tag/${version}";
    description = "Simplified Text processing";
    homepage = "https://textblob.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ idlip ];
  };
}
