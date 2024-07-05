{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pip-audit";
  version = "2.7.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pip-audit";
    rev = "refs/tags/v${version}";
    hash = "sha256-MRFfF5OygUCIdUnPvxhYk4IcLSWGgmlw2qgzPoZDniw=";
  };

  build-system = with python3.pkgs; [ flit-core ];

  dependencies =
    with python3.pkgs;
    [
      cachecontrol
      cyclonedx-python-lib
      html5lib
      packaging
      pip-api
      pip-requirements-parser
      rich
      toml
    ]
    ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = with python3.pkgs; [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pip_audit" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Tests require network access
    "test/dependency_source/test_requirement.py"
    "test/service/test_pypi.py"
    "test/service/test_osv.py"
  ];

  disabledTests = [
    # Tests requrire network access
    "test_get_pip_cache"
    "test_virtual_env"
    "test_pyproject_source"
    "test_pyproject_source_duplicate_deps"
  ];

  meta = with lib; {
    description = "Tool for scanning Python environments for known vulnerabilities";
    homepage = "https://github.com/trailofbits/pip-audit";
    changelog = "https://github.com/pypa/pip-audit/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pip-audit";
  };
}
