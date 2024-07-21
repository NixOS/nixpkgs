{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  numpy,
  cython,
  rdp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplification";
  version = "0.7.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urschrei";
    repo = "simplification";
    rev = "refs/tags/v${version}";
    hash = "sha256-DgPzcpg6x7kkNfOGypbdVys5iYMyLlf+SjOE1Mr7A+A=";
  };

  prePatch = ''
    cp ${rdp}/{include/header.h,lib/librdp.so} src/simplification
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    numpy
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportCheck = [ "simplification" ];

  meta = {
    description = "Very fast Python line simplification using either the RDP or Visvalingam-Whyatt algorithm implemented in Rust";
    changelog = "https://github.com/urschrei/simplification/releases/tag/v${version}";
    homepage = "https://github.com/urschrei/simplification";
    license = lib.licenses.blueOak100;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
