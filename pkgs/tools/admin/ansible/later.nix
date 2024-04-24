{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ansible-later";
  version = "3.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7k81eEcM+BXNrln6+Lu0+1LjsZdYkUidrRQCdlBbQB8=";
  };

  patches = [
    # https://github.com/thegeeklab/ansible-later/pull/658
    (fetchpatch {
      name = "poetry-dynamic-versioning-pep517.patch";
      url = "https://github.com/thegeeklab/ansible-later/commit/a2c278fb45769648df1439df5bb25883dddfc58a.patch";
      hash = "sha256-++CiwwHZoaPC8XHaYbNQeU3zqEi2a4eIYbuSQkO0jTI=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ansiblelater --cov-report=xml:coverage.xml --cov-report=term --no-cov-on-fail" ""
  '';

  pythonRelaxDeps = [
    "anyconfig"
    "flake8"
    "jsonschema"
    "pathspec"
    "python-json-logger"
    "PyYAML"
    "toolz"
    "unidiff"
    "yamllint"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ansible
    ansible-core
    anyconfig
    appdirs
    colorama
    flake8
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    pyyaml
    toolz
    unidiff
    yamllint
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  pythonImportsCheck = [
    "ansiblelater"
  ];

  meta = with lib; {
    description = "Best practice scanner for Ansible roles and playbooks";
    mainProgram = "ansible-later";
    homepage = "https://github.com/thegeeklab/ansible-later";
    changelog = "https://github.com/thegeeklab/ansible-later/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}
