{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ansible-later";
  version = "4.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-4ZHCnLeG5gr0UtKQLU+6xnTxUbxnLcmDd51Psnaa42I=";
  };

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    pyyaml
    ansible-core
    ansible
    anyconfig
    appdirs
    colorama
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    toolz
    unidiff
    yamllint
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ansiblelater"
  ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  meta = {
    description = "Best practice scanner for Ansible roles and playbooks";
    mainProgram = "ansible-later";
    homepage = "https://github.com/thegeeklab/ansible-later";
    changelog = "https://github.com/thegeeklab/ansible-later/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tboerger ];
  };
}
