{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # ansible doesn't support resolvelib > 0.6.0 and can't have an override
      resolvelib = super.resolvelib.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.1";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = version;
          sha256 = "1qpd0gg9yl0kbamlgjs9pkxd39kx511kbc92civ77v0ka5sw8ca0";
        };
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "pip-audit";
  version = "2.4.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bpAs7xXWvBVGzbX6Fij71BnEMpqYjSSCtWjuA/EFms8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    cachecontrol
    cyclonedx-python-lib
    html5lib
    lockfile
    packaging
    pip-api
    pip-requirements-parser
    progress
    resolvelib
    rich
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pip_audit"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Tests require network access
    "test/dependency_source/test_requirement.py"
    "test/dependency_source/resolvelib/test_resolvelib.py"
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
  };
}
