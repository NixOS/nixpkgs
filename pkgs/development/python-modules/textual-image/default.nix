{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  rich,

  # tests
  pillow,
  pytestCheckHook,
  syrupy,

  setuptools,
}:

buildPythonPackage rec {
  pname = "textual-image";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lnqs";
    repo = "textual-image";
    tag = "v${version}";
    hash = "sha256-tmQxCSlcUZy0oEk+EX7Bny75GZ3SOGSRXCNbyo1vLf8=";
  };

  buildInputs = [ setuptools ];

  dependencies = [
    pillow
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "textual_image" ];

  doCheck = true;

  meta = {
    description = "Render images in the terminal with Textual and rich";
    homepage = "https://github.com/lnqs/textual-image/";
    changelog = "https://github.com/lnqs/textual-image/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ gaelj ];
  };
}
