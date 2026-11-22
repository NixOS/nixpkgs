{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-avatar";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "streamlit_avatar";
    inherit version;
    hash = "sha256-AjiTvYDbWpI9OX/GTSfHqXIQfaTwvqD+uZoy+TY/JpE=";
  };

  build-system = [ setuptools ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "streamlit_avatar" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Component to display avatar icon in Streamlit";
    homepage = "https://pypi.org/project/streamlit-avatar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
