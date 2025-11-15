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
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cj0GpHz3dZRB2jQYxIQ67TeXqZi+uiEIxiRaICD4OwE=";
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
