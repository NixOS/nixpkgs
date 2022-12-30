{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, rich
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-a32H5X3VsfYuU1TkOH5uGn1eDLvGUDI6WhXEQ0AKwq8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    rich
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^12.3.0"' 'rich = "*"'
  '';

  pythonImportsCheck = [
    "textual"
  ];

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
