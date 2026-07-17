{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-card";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "streamlit_card";
    inherit version;
    hash = "sha256-gAHNXt2Kbi2zbugfN9xkXwj3jCGiupaEAxdsaLTzPLE=";
  };

  build-system = [ setuptools ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "streamlit_card" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Streamlit component to make UI cards";
    homepage = "https://github.com/gamcoh/st-card";
    changelog = "https://github.com/gamcoh/st-card/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
