{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tcxreader";
  version = "0.4.10";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "alenrajsp";
    repo = "tcxreader";
    rev = "refs/tags/v${version}";
    hash = "sha256-qTAqRzrHFj0nEujlkBohLaprIvvkSYhcDoRfqWIJMjo=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tcxreader" ];

  meta = with lib; {
    description = "Reader for Garmin’s TCX file format";
    homepage = "https://github.com/alenrajsp/tcxreader";
    changelog = "https://github.com/alenrajsp/tcxreader/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
