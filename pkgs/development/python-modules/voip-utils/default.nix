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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voip-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-ONvbkYP1hGMYOVZs5gvs/cr+Tde9gT3jloP6veqE/Ac=";
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
