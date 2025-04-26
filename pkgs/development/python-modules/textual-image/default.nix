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
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lnqs";
    repo = "textual-image";
    tag = "v${version}";
    hash = "sha256-ik/zvnxXN5u2jXHfsGsCLnymZZ+IQiixagOJdEMRDlw=";
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
