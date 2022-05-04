{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rich-cli";
  version = "1.7.0";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-fporylec9H+9G2v8D0O32ek7OQs3YRSma1xOpakClqk=";
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
      --replace 'rich = "^12.3.0"' 'rich = "*"'
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
