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
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voip-utils";
    tag = "v${version}";
    hash = "sha256-CI6YCT88ay4tDWHwaTL0Wr4b07mCn7440HdWE9+nxAw=";
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
