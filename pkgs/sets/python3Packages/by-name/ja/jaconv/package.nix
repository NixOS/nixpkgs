{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaconv";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikegami-yukino";
    repo = "jaconv";
    tag = "v${version}";
    hash = "sha256-W8vQsMcpsozPdYGFXZyka/8f9XXF3r+yR7qHkNZOhVI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jaconv" ];

  meta = {
    description = "Python Japanese character interconverter for Hiragana, Katakana, Hankaku and Zenkaku";
    homepage = "https://github.com/ikegami-yukino/jaconv";
    changelog = "https://github.com/ikegami-yukino/jaconv/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
