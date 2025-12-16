{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-javascript";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-naUXZSKgrPLDnTsL7J+Fb92Oo8cLsQZoQaVGqxNIrh0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "streamlit_javascript" ];

  meta = {
    description = "Streamlit component to execute javascript code";
    homepage = "https://github.com/thunderbug1/streamlit-javascript";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.carman ];
  };
}
