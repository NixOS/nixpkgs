{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "iredis";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3031094db0aa03d48b6f9be750e32d3e901942a96cc05283029086cb871cd81";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click>=7.0,<8.0" "click" \
      --replace "wcwidth==0.1.9" "wcwidth" \
      --replace "redis>=3.4.0,<4.0.0" "redis" \
      --replace "mistune>=2.0,<3.0" "mistune"
  '';

  propagatedBuildInputs = [
    pygments
    click
    configobj
    importlib-resources
    mistune_2_0
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
