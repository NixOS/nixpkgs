{
  lib,
  buildPythonPackage,
  setuptools,
  sphinx,
  cairosvg,
  inkscape,
  librsvg,
  fetchPypi,

  withCairosvg ? false,
  withInkscape ? false,
  withLibrsvg ? false,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-svg2pdfconverter";
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_svg2pdfconverter";
    hash = "sha256-+11Re2NMVilSIATFntzk2QUNiYIkCMq0UsfVL+WumCQ=";
  };

  build-system = [ setuptools ];

  dependencies =
    [ sphinx ]
    ++ lib.optional withCairosvg cairosvg
    ++ lib.optional withInkscape inkscape
    ++ lib.optional withLibrsvg librsvg;

  doCheck = false; # no tests

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx SVG to PDF converter extension";
    homepage = "https://pypi.org/project/sphinxcontrib-svg2pdfconverter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dansbandit ];
  };
}
