{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "telegram-text";
  version = "0.1.2";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SKY-ALIN";
    repo = "telegram-text";
    rev = "v${version}";
    hash = "sha256-p8SVQq7IvkVuOFE8VDugROLY5Wk0L2HmXyacTzFFSP4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python markup module for Telegram messenger";
    downloadPage = "https://github.com/SKY-ALIN/telegram-text";
    homepage = "https://telegram-text.alinsky.tech/";
    changelog = "https://github.com/SKY-ALIN/telegram-text/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
