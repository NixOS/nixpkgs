{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.10.1";
  disabled = python3Packages.pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N+aAH2vgDV1YU7iIHbH/276bCBfGxhuy2ceWL2z/oI8=";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt-toolkit
    pygments
    sqlparse
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "litecli" ];

  disabledTests = [
    "test_auto_escaped_col_names"
  ];

  meta = with lib; {
    description = "Command-line interface for SQLite";
    mainProgram = "litecli";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
