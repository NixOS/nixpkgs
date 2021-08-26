{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.6.0";
  disabled = python3Packages.pythonOlder "3.4";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-TSdOFHW007syOEg4gwvEqDiJkrfLgRmqjP/H/6oBZ/k=";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt-toolkit
    pygments
    sqlparse
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "litecli" ];

  meta = with lib; {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
