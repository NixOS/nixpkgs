{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.8.0";
  disabled = python3Packages.pythonOlder "3.4";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-AvaSdHlwRlw7rN/o8GjcXZbyXVsrEh+XF37wVTBEED4=";
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
