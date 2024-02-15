{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      packaging = super.packaging.overridePythonAttrs (oldAttrs: rec {
        version = "21.3";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-3UfEKSfYmrkR5gZRiQfMLTofOLvQJjhZcGQ/nFuOz+s=";
        };
        nativeBuildInputs = with python3.pkgs; [ setuptools ];
        propagatedBuildInputs = with python3.pkgs; [ pyparsing six ];
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "skjold";
  version = "0.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "twu";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rsdstzNZvokYfTjEyPrWR+0SJpf9wL0HAesq8+A+tPY=";
  };

  nativeBuildInputs = with py.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with py.pkgs; [
    click
    packaging
    pyyaml
    toml
  ];

  nativeCheckInputs = with py.pkgs; [
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

  pythonImportsCheck = [
    "skjold"
  ];

  meta = with lib; {
    description = "Tool to Python dependencies against security advisory databases";
    homepage = "https://github.com/twu/skjold";
    changelog = "https://github.com/twu/skjold/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
