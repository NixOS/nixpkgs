{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mV5b/J9wX9niiYtlmAUouaAm9mY2zTtDmex7FNWcezQ=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    rich
    click
    requests
    textual
    rich-rst
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^12.4.0"' 'rich = "*"' \
      --replace 'textual = "^0.1.18"' 'textual = "*"'
  '';

  pythonImportsCheck = [
    "rich_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface to Rich";
    homepage = "https://github.com/Textualize/rich-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
