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
  version = "0.20.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+9GjMHUy6d3bj1AoSHRVngECDnm1/lrkwdpwmp4gh+o=";
  };

  build-system = [ flit-core ];

  dependencies = [ nltk ];

  # Test process requires pytestCheckHook and network access to download wordnet
  # Error: 'wordnet not found' 'Attempted to load corpora/wordnet'
  doCheck = false;

  pythonImportsCheck = [ "textblob" ];

  meta = {
    changelog = "https://github.com/sloria/TextBlob/releases/tag/${version}";
    description = "Simplified Text processing";
    homepage = "https://textblob.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ idlip ];
  };
}
