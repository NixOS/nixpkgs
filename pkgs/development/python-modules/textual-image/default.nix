{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  rich,
  pillow,

  # tests
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-image";
  version = "0.14.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lnqs";
    repo = "textual-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iGjpEUkr8r74Bb7F5Zmx72hvHLshO8q+2SSRfHlvWiE=";
  };

  build-system = [ uv-build ];

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
