{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlfluff";
  version = "0.6.1";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0p5vjpfmy52hbq6mz8svvxrg9757cvgj0cbvaa0340309953ilvj";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    cached-property
    click
    colorama
    configparser
    diff-cover
    jinja2
    oyaml
    pathspec
    pytest
    tblib
    toml
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  checkInputs = with python3.pkgs; [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # dbt is not available yet
    "test/core/templaters/dbt_test.py"
    # Don't run the plugin related tests
    "test/core/plugin_test.py"
    "plugins/sqlfluff-plugin-example/test/rules/rule_test_cases_test.py"
  ];

  disabledTests = [
    # dbt is not available yet
    "test__linter__skip_dbt_model_disabled"
    "test_rules__test_helper_has_variable_introspection"
    "test__rules__std_file_dbt"
  ];

  pythonImportsCheck = [ "sqlfluff" ];

  meta = with lib; {
    description = "SQL linter and auto-formatter";
    homepage = "https://www.sqlfluff.com/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
