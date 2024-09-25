{ lib
, python3
, fetchPypi
, ansible
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ansible-lint";
  version = "24.9.2";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "ansible_lint";
    hash = "sha256-fP9sWvEO+Za3xgEMvUjJFZJ2SuCY8rBUCHJomaEGan8=";
  };

  postPatch = ''
    # it is fine if lint tools are missing
    substituteInPlace conftest.py \
      --replace "sys.exit(1)" ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "ruamel.yaml"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # https://github.com/ansible/ansible-lint/blob/master/.config/requirements.in
    ansible-core
    ansible-compat
    black
    filelock
    importlib-metadata
    jsonschema
    packaging
    pyyaml
    rich
    ruamel-yaml
    subprocess-tee
    wcmatch
    yamllint
  ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  nativeCheckInputs = with python3.pkgs; [
    flaky
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    # ansible wants to write to $HOME and crashes if it can't
    export HOME=$(mktemp -d)
    export PATH=$PATH:${lib.makeBinPath [ ansible ]}

    # create a working ansible-lint executable
    export PATH=$PATH:$PWD/src/ansiblelint
    ln -rs src/ansiblelint/__main__.py src/ansiblelint/ansible-lint
    patchShebangs src/ansiblelint/__main__.py

    # create symlink like in the git repo so test_included_tasks does not fail
    ln -s ../roles examples/playbooks/roles
  '';

  disabledTests = [
    # requires network
    "test_cli_auto_detect"
    "test_install_collection"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_wrong_version"
    # re-execs ansible-lint which does not works correct
    "test_custom_kinds"
    "test_run_inside_role_dir"
    "test_run_multiple_role_path_no_trailing_slash"
    "test_runner_exclude_globs"
    "test_discover_lintables_umlaut"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible ]}" ];

  meta = with lib; {
    description = "Best practices checker for Ansible";
    mainProgram = "ansible-lint";
    homepage = "https://github.com/ansible/ansible-lint";
    changelog = "https://github.com/ansible/ansible-lint/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sengaya ];
  };
}
