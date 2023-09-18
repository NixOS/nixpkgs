{ lib
, stdenv
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iredis";
  version = "1.13.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "laixintao";
    repo = "iredis";
    rev = "refs/tags/v${version}";
    hash = "sha256-dGOB7emhuP+V0pHlSdS1L1OC4jO3jtf5RFOy0UFYiuY=";
  };

  pythonRelaxDeps = [
    "configobj"
    "wcwidth"
    "click"
    "packaging"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygments
    click
    configobj
    mistune
    packaging
    pendulum
    prompt-toolkit
    redis
    wcwidth
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pexpect
  ];

  pytestFlagsArray = [
    # Fails on sandbox
    "--ignore=tests/unittests/test_client.py"
    "--deselect=tests/unittests/test_render_functions.py::test_render_unixtime_config_raw"
    "--deselect=tests/unittests/test_render_functions.py::test_render_time"
    # Only execute unittests, because cli tests require a running Redis
    "tests/unittests/"
  ] ++ lib.optionals stdenv.isDarwin [
    # Flaky test
    "--deselect=tests/unittests/test_utils.py::test_timer"
  ];

  pythonImportsCheck = [ "iredis" ];

  meta = with lib; {
    description = "A Terminal Client for Redis with AutoCompletion and Syntax Highlighting";
    changelog = "https://github.com/laixintao/iredis/raw/${src.rev}/CHANGELOG.md";
    homepage = "https://iredis.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
