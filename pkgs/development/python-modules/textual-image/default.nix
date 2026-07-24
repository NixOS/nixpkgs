{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  rich,
  pillow,

  # tests
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-image";
  version = "0.13.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lnqs";
    repo = "textual-image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7TPng2rBYVY1r7Y1pkSZYo4r+MdyD8HzqJAMpzyNqZE=";
  };

  build-system = [ hatchling ];

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
