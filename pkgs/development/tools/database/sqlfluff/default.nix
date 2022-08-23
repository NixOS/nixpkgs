{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlfluff";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-IPBq1jFUCJXG/XW1M1AoD3pfj2/jnGR1NLgbO5zcqFg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    cached-property
    chardet
    click
    colorama
    configparser
    diff-cover
    jinja2
    oyaml
    pathspec
    pytest
    regex
    tblib
    toml
    tqdm
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optionals (pythonOlder "3.8") [
    backports.cached-property
    importlib_metadata
  ];

  checkInputs = with python3.pkgs; [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Don't run the plugin related tests
    "test/core/plugin_test.py"
    "plugins/sqlfluff-templater-dbt"
    "plugins/sqlfluff-plugin-example/test/rules/rule_test_cases_test.py"
  ];

  disabledTests = [
    # dbt is not available yet
    "test__linter__skip_dbt_model_disabled"
    "test_rules__test_helper_has_variable_introspection"
    "test__rules__std_file_dbt"
  ];

  pythonImportsCheck = [
    "sqlfluff"
  ];

  meta = with lib; {
    description = "SQL linter and auto-formatter";
    homepage = "https://www.sqlfluff.com/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
