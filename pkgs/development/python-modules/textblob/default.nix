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
  version = "0.18.0.post0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gTHFLGMLzfYdBMNZ+TnJjVuDagH7oiTZ564i/CdODMs=";
  };

  build-system = [ flit-core ];

  dependencies = [ nltk ];

  doCheck = true;

  pythonImportsCheck = [ "textblob" ];

  meta = with lib; {
    changelog = "https://github.com/sloria/TextBlob/releases/tag/${version}";
    description = "Simplified Text processing";
    homepage = "https://textblob.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ idlip ];
  };
}
