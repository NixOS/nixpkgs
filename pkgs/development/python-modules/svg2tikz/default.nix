{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  inkex,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svg2tikz";
  version = "3.3.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    tag = "v${version}";
    hash = "sha256-wc5yzfWWixzO73s+jADpoQli0f3bmu2tBrGgj6DYnUM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    inkex
    lxml
  ];

  pythonRelaxDeps = [
    "inkex"
    "lxml"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svg2tikz" ];

  meta = {
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      gal_bolle
    ];
  };
}
