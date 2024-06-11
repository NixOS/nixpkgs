{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "skjold";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twu";
    repo = "skjold";
    rev = "refs/tags/v${version}";
    hash = "sha256-/ltaRs2WZXbrG3cVez+QIwupJrsV550TjOALbHX9Z0I=";
  };

  pythonRelaxDeps = [ "packaging" ];

  build-system = with python3.pkgs; [ poetry-core ];

  nativeBuildInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  dependencies = with python3.pkgs; [
    click
    packaging
    pyyaml
    toml
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-mock
    pytest-watch
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Too sensitive to pass
    "tests/test_cli.py"
  ];

  disabledTests = [
    # Requires network access
    "pyup-werkzeug"
    "test_ensure_accessing_advisories_triggers_update"
    "test_ensure_accessing_advisories_triggers_update"
    "test_ensure_gemnasium_update"
    "test_ensure_missing_github_token_raises_usage_error"
    "test_ensure_pypi_advisory_db_update"
    "test_ensure_source_is_affected_single"
    "test_osv_advisory_with_vulnerable_package_via_osv_api"
    "urllib3"
  ];

  pythonImportsCheck = [ "skjold" ];

  meta = with lib; {
    description = "Tool to Python dependencies against security advisory databases";
    homepage = "https://github.com/twu/skjold";
    changelog = "https://github.com/twu/skjold/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
