{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  inkex,
  lxml,
  pytestCheckHook,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "svg2tikz";
  version = "3.1.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    rev = "refs/tags/v${version}";
    hash = "sha256-lL+CQGZMK+rxjw2kTNE6kK3FCt6ARsAD6ROMsXWwDCs=";
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

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svg2tikz" ];

  meta = with lib; {
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      dotlambda
      gal_bolle
    ];
  };
}
