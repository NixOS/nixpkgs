{ lib
, stdenv
, azure-core
, bokeh
, buildPythonPackage
, click
, docker_pycreds
, fetchFromGitHub
, flask
, git
, GitPython
, jsonref
, jsonschema
, matplotlib
, nbconvert
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
, python-dateutil
, pythonOlder
, pyyaml
, requests
, scikit-learn
, sentry-sdk
, setproctitle
, setuptools
, shortuuid
, tqdm
}:

buildPythonPackage rec {
  pname = "wandb";
  version = "0.12.16";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "client";
    rev = "v${version}";
    hash = "sha256-ZY7nTj93piTEeHhW+H+nQ+ws2dDmmY6u3p7uz296PbA=";
  };

  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    click
    docker_pycreds
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
  ];

  # wandb expects git to be in PATH. See https://gist.github.com/samuela/57aeee710e41ab2bf361b7ed8fbbeabf
  # for the error message, and an example usage here: https://github.com/wandb/client/blob/d5f655b7ca7e3eac2f3a67a84bc5c2a664a31baf/wandb/sdk/internal/meta.py#L128.
  # See https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621 as to
  # why we don't put it in propagatedBuildInputs. Note that this is difficult to
  # test offline due to https://github.com/wandb/client/issues/3519.
  postInstall = ''
    mkdir -p $out/bin
    ln -s ${git}/bin/git $out/bin/git
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
    azure-core
    bokeh
    flask
    jsonref
    jsonschema
    matplotlib
    # Oddly enough, nbclient does not provide the `nbclient` module. Rather it's
    # available in nbconvert. See https://github.com/NixOS/nixpkgs/issues/171493#issuecomment-1116960488.
    nbconvert
    nbformat
    pandas
    pydantic
    pytest-mock
    pytest-xdist
    pytestCheckHook
    scikit-learn
    tqdm
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
    "tests/test_model_workflows.py"

    # Fails and borks the pytest runner as well.
    "tests/wandb_test.py"

    # Tries to access /homeless-shelter
    "tests/test_tables.py"
  ];

  # Disable test that fails on darwin due to issue with python3Packages.psutil:
  # https://github.com/giampaolo/psutil/issues/1219
  disabledTests = lib.optional stdenv.isDarwin [
    "test_tpu_system_stats"
  ];

  pythonImportsCheck = [
    "wandb"
  ];

  meta = with lib; {
    description = "A CLI and library for interacting with the Weights and Biases API";
    homepage = "https://github.com/wandb/client";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
