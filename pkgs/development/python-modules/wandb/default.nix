{ azure-core
, bokeh
, buildPythonPackage
, click
, configparser
, docker_pycreds
, fetchFromGitHub
, flask
, git
, GitPython
, jsonref
, jsonschema
, lib
, matplotlib
, nbformat
, pandas
, pathtools
, promise
, protobuf
, psutil
, pydantic
, pytest-mock
, pytest-xdist
, pytestCheckHook
, python
, python-dateutil
, pyyaml
, requests
, scikit-learn
, sentry-sdk
, setproctitle
, setuptools
, shortuuid
, stdenv
, tqdm
, yaspin
}:

buildPythonPackage rec {
  pname = "wandb";
  version = "0.12.11";

  src = fetchFromGitHub {
    owner = pname;
    repo = "client";
    rev = "v${version}";
    sha256 = "0av4vv4llan40678bw0vlah0gn6hjg5pdqwq0c5cv15lqrdb8g32";
  };

  # The wandb requirements.txt does not distinguish python2/3 dependencies. We
  # need to drop the subprocess32 dependency when building for python3.
  patchPhase = ''
    substituteInPlace requirements.txt --replace "subprocess32>=3.5.3" ""
  '';

  # git is not a setup.py dependency of wandb, but wandb does expect git to be
  # in PATH. See https://gist.github.com/samuela/57aeee710e41ab2bf361b7ed8fbbeabf
  # for the error message, and an example usage here: https://github.com/wandb/client/blob/master/wandb/sdk/internal/meta.py#L139-L141.
  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    click
    configparser
    docker_pycreds
    git
    GitPython
    pathtools
    promise
    protobuf
    psutil
    python-dateutil
    pyyaml
    requests
    sentry-sdk
    setproctitle
    setuptools
    shortuuid
    yaspin
  ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/test_cli.py"
    "tests/test_data_types.py"
    "tests/test_file_stream.py"
    "tests/test_file_upload.py"
    "tests/test_footer.py"
    "tests/test_internal_api.py"
    "tests/test_label_full.py"
    "tests/test_login.py"
    "tests/test_meta.py"
    "tests/test_metric_full.py"
    "tests/test_metric_internal.py"
    "tests/test_mode_disabled.py"
    "tests/test_mp_full.py"
    "tests/test_public_api.py"
    "tests/test_redir.py"
    "tests/test_runtime.py"
    "tests/test_sender.py"
    "tests/test_start_method.py"
    "tests/test_tb_watcher.py"
    "tests/test_telemetry_full.py"
    "tests/wandb_agent_test.py"
    "tests/wandb_artifacts_test.py"
    "tests/wandb_integration_test.py"
    "tests/wandb_run_test.py"
    "tests/wandb_settings_test.py"
    "tests/wandb_sweep_test.py"
    "tests/wandb_verify_test.py"

    # Fails and borks the pytest runner as well.
    "tests/wandb_test.py"

    # Tries to access /homeless-shelter
    "tests/test_tables.py"
  ];

  checkInputs = [
    azure-core
    bokeh
    flask
    jsonref
    jsonschema
    matplotlib
    nbformat
    pandas
    pydantic
    pytest-mock
    pytest-xdist
    pytestCheckHook
    scikit-learn
    tqdm
  ];

  pythonImportsCheck = [ "wandb" ];

  meta = with lib; {
    description = "A CLI and library for interacting with the Weights and Biases API";
    homepage = "https://github.com/wandb/client";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
