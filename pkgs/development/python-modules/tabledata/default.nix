{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools-scm,
  dataproperty,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "tabledata";
    tag = "v${version}";
    hash = "sha256-kZAEKUOcxb3fK3Oh6+4byJJlB/xzDAEGNpUDEKyVkhs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dataproperty
    typepy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/thombashi/tabledata";
    description = "Library to represent tabular data";
    changelog = "https://github.com/thombashi/tabledata/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ genericnerdyusername ];
    license = lib.licenses.mit;
  };
}
