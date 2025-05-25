{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  inkex,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svg2tikz";
  version = "3.3.1";

  disabled = pythonOlder "3.7";

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
    "lxml"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svg2tikz" ];

  meta = with lib; {
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      dotlambda
      gal_bolle
    ];
  };
}
