{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "turrishw";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turris-cz";
    repo = "turrishw";
    tag = "v${version}";
    hash = "sha256-elu2f54asdzdn7wQT2CKo8kVYnc1KTakRyr8Nxu+XNw=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests don't work on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "turrishw" ];

  meta = {
    description = "Python library and program for Turris hardware listing";
    homepage = "https://github.com/turris-cz/turrishw";
    changelog = "https://github.com/turris-cz/turrishw/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
