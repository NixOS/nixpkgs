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
