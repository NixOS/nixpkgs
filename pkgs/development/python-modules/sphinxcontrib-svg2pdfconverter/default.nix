{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sphinxcontrib-svg2pdfconverter";
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+11Re2NMVilSIATFntzk2QUNiYIkCMq0UsfVL+WumCQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = [ python3Packages.sphinx ];

  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx SVG to PDF converter extension";
    homepage = "https://pypi.org/project/sphinxcontrib-svg2pdfconverter/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dansbandit ];
  };
}
