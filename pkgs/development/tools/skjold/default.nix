{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "skjold";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "twu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xz6N7/LS3wOymh9tet8OLgsSaretzuMU4hQd+LeUPJ4=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  patches = [
    # Switch to poetry-core, https://github.com/twu/skjold/pull/91
    (fetchpatch {
      name = "switch-poetry-core.patch";
      url = "https://github.com/twu/skjold/commit/b341748c9b11798b6a5182d659a651b0f200c6f5.patch";
      sha256 = "sha256-FTZTbIudO6lYO9tLD4Lh1h5zsTeKYtflR2tbbHZ5auM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'packaging = "^21.0"' 'packaging = "*"' \
      --replace 'pyyaml = "^5.3"' 'pyyaml = "*"'
  '';

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

  pythonImportsCheck = [
    "skjold"
  ];

  meta = with lib; {
    description = "Tool to Python dependencies against security advisory databases";
    homepage = "https://github.com/twu/skjold";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
