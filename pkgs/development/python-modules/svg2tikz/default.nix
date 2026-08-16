{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  inkex,
  lxml,
  pygobject3,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "svg2tikz";
  version = "3.3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "xyz2tex";
    repo = "svg2tikz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Bp+nr/jlu9eJqMQOlBwsmr468qUgxJqgLK2VDNT9yY=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    inkex
    lxml
    pygobject3
  ];

  pythonRelaxDeps = [
    "inkex"
    "lxml"
    "pygobject"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "svg2tikz" ];

  meta = {
    changelog = "https://github.com/xyz2tex/svg2tikz/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/xyz2tex/svg2tikz";
    description = "Set of tools for converting SVG graphics to TikZ/PGF code";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      gal_bolle
    ];
  };
})
