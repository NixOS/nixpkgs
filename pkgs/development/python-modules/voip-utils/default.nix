{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  opuslib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voip-utils";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voip-utils";
    tag = "v${version}";
    hash = "sha256-43g7ArhIZVyZ+VnzenldrQfr6kjpAxPNrK/vazYED+w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "~=" ">="
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "opuslib" ];

  dependencies = [ opuslib ];

  pythonImportsCheck = [ "voip_utils" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/voip-utils/blob/${src.rev}/CHANGELOG.md";
    description = "Voice over IP Utilities";
    homepage = "https://github.com/home-assistant-libs/voip-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
