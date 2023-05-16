{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlfluff";
<<<<<<< HEAD
  version = "2.3.2";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-buDDu5UQmO1ImWXzqwlFZHYbn2FUjAxs8KbQX+g/mvg=";
=======
    hash = "sha256-kUc3y9OlaQ72MsESrVd+eqm4xulFixYMKAIMeP3+NOc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    backports.cached-property
    importlib_metadata
  ];

  nativeCheckInputs = with python3.pkgs; [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Don't run the plugin related tests
    "plugins/sqlfluff-plugin-example/test/rules/rule_test_cases_test.py"
    "plugins/sqlfluff-templater-dbt"
    "test/core/plugin_test.py"
    "test/diff_quality_plugin_test.py"
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
    changelog = "https://github.com/sqlfluff/sqlfluff/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
