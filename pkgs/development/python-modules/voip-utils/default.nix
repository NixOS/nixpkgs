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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voip-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-/DBBTL+t0VQJL43HgXGdhMHMKr8uBEkJ7Mf7Xp1mwhU=";
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

  # no tests as of v0.1.0
  doCheck = false;

  meta = {
    changelog = "https://github.com/home-assistant-libs/voip-utils/blob/${src.rev}/CHANGELOG.md";
    description = "Voice over IP Utilities";
    homepage = "https://github.com/home-assistant-libs/voip-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
