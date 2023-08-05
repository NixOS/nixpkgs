{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonApplication rec {
  pname = "iredis";
  version = "1.13.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MWzbmuxUKh0yBgar1gk8QGJQwbHtINsbCsbTM+RLmQo=";
  };

  pythonRelaxDeps = [
    "configobj"
    "wcwidth"
    "click"
    "packaging"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    pygments
    click
    configobj
    importlib-resources
    mistune
    packaging
    pendulum
    prompt-toolkit
    redis
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pexpect
  ];

  pytestFlagsArray = [
    # Fails on sandbox
    "--ignore=tests/unittests/test_client.py"
    "--deselect=tests/unittests/test_render_functions.py::test_render_unixtime_config_raw"
    "--deselect=tests/unittests/test_render_functions.py::test_render_time"
    "--deselect=tests/unittests/test_entry.py::test_command_shell_options_higher_priority"
    # Only execute unittests, because cli tests require a running Redis
    "tests/unittests/"
  ] ++ lib.optionals stdenv.isDarwin [
    # Flaky test
    "--deselect=tests/unittests/test_utils.py::test_timer"
  ];

  pythonImportsCheck = [ "iredis" ];

  meta = with lib; {
    description = "A Terminal Client for Redis with AutoCompletion and Syntax Highlighting";
    changelog = "https://github.com/laixintao/iredis/raw/v${version}/CHANGELOG.md";
    homepage = "https://iredis.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
