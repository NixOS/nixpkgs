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
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufo2ft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0IXOWUEoQY+QJHJDR3YR86+OkO3pIdGYUfQSt+SF80I=";
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
