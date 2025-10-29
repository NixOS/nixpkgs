{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "timy";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ramonsaraiva";
    repo = "timy";
    rev = "36a97e55f058de002a0da4f2a8e18c00d944821c";
    hash = "sha256-4Opaph8Q1tQH+C/Epur8AA26RN4vO944DjCg0zDJqxM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Minimalist measurement of python code time";
    homepage = "https://github.com/ramonsaraiva/timy";
    license = licenses.mit;
    maintainers = with maintainers; [ flandweber ];
  };
}
