{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "turrishw";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "turris-cz";
    repo = "turrishw";
    tag = "v${version}";
    hash = "sha256-LQ1ebcVQo7jixAKOPg/oNBnRU8AZebHANfDU4lamB8g=";
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
