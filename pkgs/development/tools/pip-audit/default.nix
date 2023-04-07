{ lib
, fetchFromGitHub
, python3
}:
let
  py = python3.override {
    packageOverrides = self: super: {

      cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (oldAttrs: rec {
        version = "2.7.1";
        src = fetchFromGitHub {
          owner = "CycloneDX";
          repo = "cyclonedx-python-lib";
          rev = "v${version}";
          hash = "sha256-c/KhoJOa121/h0n0GUazjUFChnUo05ThD+fuZXc5/Pk=";
        };
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "pip-audit";
  version = "2.5.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aByzVPQADTNz5rVzmkNH/zk4u+RkWPcfk0sQhR3K2cQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    cachecontrol
    cyclonedx-python-lib
    html5lib
    packaging
    pip-api
    pip-requirements-parser
    rich
    toml
  ] ++ cachecontrol.optional-dependencies.filecache;

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
