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
  version = "3.3.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    tag = "v${version}";
    hash = "sha256-LG8u23pEovF05ApjyxA6AebEjmVtxPxpTp9f2DwkwpM=";
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
