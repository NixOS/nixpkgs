{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  opuslib-next,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voip-utils";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voip-utils";
    tag = "v${version}";
    hash = "sha256-gtLcUUiZlrBIilowTT6jB2BcSEfGwqu3vop8I0zDwXo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "~=" ">="
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "opuslib-next" ];

  dependencies = [ opuslib-next ];

  pythonImportsCheck = [ "voip_utils" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/voip-utils/blob/${src.tag}/CHANGELOG.md";
    description = "Voice over IP Utilities";
    homepage = "https://github.com/home-assistant-libs/voip-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
