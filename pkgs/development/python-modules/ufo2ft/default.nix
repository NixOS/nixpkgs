{
  lib,
  booleanoperations,
  buildPythonPackage,
  cffsubr,
  compreffor,
  defcon,
  fetchFromGitHub,
  fontmath,
  fonttools,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  skia-pathops,
  syrupy,
  ufolib2,
  uharfbuzz,
}:

buildPythonPackage (finalAttrs: {
  pname = "ufo2ft";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufo2ft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-McMhpGIvQHpsOe3jza6E3b72cKiY8gr8W9OY2Mg9JvE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fontmath
    fonttools
    booleanoperations
    cffsubr
  ]
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.ufo;

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
    ufolib2
    uharfbuzz
    defcon
  ]
  ++ finalAttrs.passthru.optional-dependencies.compreffor
  ++ finalAttrs.passthru.optional-dependencies.pathops;

  optional-dependencies = {
    compreffor = [ compreffor ];
    cffsubr = [ ];
    pathops = [ skia-pathops ];
  };

  pythonImportsCheck = [ "ufo2ft" ];

  meta = {
    description = "Bridge from UFOs to FontTools objects";
    homepage = "https://github.com/googlefonts/ufo2ft";
    changelog = "https://github.com/googlefonts/ufo2ft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
