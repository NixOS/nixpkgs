{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "iredis";
  version = "1.13.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1e4e7936d0be456f70a39abeb1c97d931f66ccd60e891f4fd796ffb06dfeaf9";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'click = "^7.0"' 'click = "*"' \
      --replace 'wcwidth = "0.1.9"' 'wcwidth = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
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

  checkInputs = [
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
