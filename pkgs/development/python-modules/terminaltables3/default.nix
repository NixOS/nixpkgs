{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  python312Packages,
}:

buildPythonPackage rec {
  pname = "terminaltables3";
  version = "4.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  build-system = [
    poetry-core
  ];

  src = fetchFromGitHub {
    owner = "matthewdeanmartin";
    repo = "terminaltables3";
    rev = "f1c465b36eb9b91a984d8864b21376e7c37075b8"; # Untagged commit 4.0.0
    hash = "sha256-UcEovh1Eb4QNPwLGDjCphPlJSSkOdhCJ2fK3tuSWOTc=";
  };

  pythonImportsCheck = [ "terminaltables3" ];

  # Tests are broken upstream
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    python312Packages.colorama
    python312Packages.colorclass
    python312Packages.termcolor
  ];

  meta = with lib; {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/matthewdeanmartin/terminaltables3";
    license = licenses.mit;
    maintainers = with maintainers; [ kekschen ];
  };
}
