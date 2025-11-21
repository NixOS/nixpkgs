{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pyobjc-core,
  pyobjc-framework-Cocoa,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "utitools";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "utitools";
    tag = "v${version}";
    hash = "sha256-oI+a+sc9+qi7aFP0dLINAQekib/9pZm10A5jhVIHWvo=";
  };

  build-system = [ flit-core ];
  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  pythonImportsCheck = [ "utitools" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities for working with Uniform Type Identifiers";
    homepage = "https://github.com/RhetTbull/utitools";
    changelog = "https://github.com/RhetTbull/osxphotos/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
