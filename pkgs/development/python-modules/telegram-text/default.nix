{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "telegram-text";
  version = "0.2.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SKY-ALIN";
    repo = "telegram-text";
    rev = "refs/tags/v${version}";
    hash = "sha256-eUy4kyCmM/5Ag/0s9hYW2IIg+OTX2L7EsoOYivhd0pU=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python markup module for Telegram messenger";
    downloadPage = "https://github.com/SKY-ALIN/telegram-text";
    homepage = "https://telegram-text.alinsky.tech/";
    changelog = "https://github.com/SKY-ALIN/telegram-text/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
