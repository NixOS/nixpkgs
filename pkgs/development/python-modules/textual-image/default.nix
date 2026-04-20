{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  rich,
  pillow,

  # tests
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-image";
  version = "0.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lnqs";
    repo = "textual-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W0f9ZnSZ58XqiPnr9SZEv22EE4yCsvXcgNA8eJebJQo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pillow
    rich
  ];

  pythonImportsCheck = [ "textual_image" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert [+ received] == [- snapshot]
    "test_render"
  ];

  meta = {
    description = "Render images in the terminal with Textual and rich";
    homepage = "https://github.com/lnqs/textual-image/";
    changelog = "https://github.com/lnqs/textual-image/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
