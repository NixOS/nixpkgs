{ lib
, fetchFromGitHub
, python3
}:
let
  py = python3.override {
    packageOverrides = self: super: {

      dpath = super.dpath.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "06rn91n2izw7czncgql71w7acsa8wwni51njw0c6s8w4xas1arj9";
        };
        doCheck = false;
      });

      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.2.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-yKhbKNN3zHc35G4tnytPRO48Dh3qxr9G3e/HGH0weXo=";
        };
        SETUPTOOLS_SCM_PRETEND_VERSION = version;
        doCheck = false;
      });

    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "checkov";
  version = "2.0.941";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = version;
    hash = "sha256-hNmIJmxzKEaKQzqLl9LSqtMj1dTpFDeztUo2ESCHIw0=";
  };

  nativeBuildInputs = with py.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with py.pkgs; [
    aiodns
    aiohttp
    aiomultiprocess
    argcomplete
    bc-python-hcl2
    boto3
    cachetools
    cloudsplaining
    colorama
    configargparse
    cyclonedx-python-lib
    deep_merge
    detect-secrets
    docker
    dockerfile-parse
    dpath
    GitPython
    jmespath
    jsonpath-ng
    jsonschema
    junit-xml
    networkx
    packaging
    policyuniverse
    prettytable
    pycep-parser
    pyyaml
    semantic-version
    tabulate
    termcolor
    tqdm
    typing-extensions
    update_checker
  ];

  checkInputs = with py.pkgs; [
    aioresponses
    mock
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cyclonedx-python-lib>=0.11.0,<1.0.0" "cyclonedx-python-lib>=0.11.0" \
      --replace "prettytable>=3.0.0" "prettytable"
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # No API key available
    "api_key"
    # Requires network access
    "TestSarifReport"
    # Will probably be fixed in one of the next releases
    "test_valid_cyclonedx_bom"
    "test_record_relative_path_with"
    "test_record_relative_path_with_relative_dir"
    # Requires prettytable release which is only available in staging
    "test_skipped_check_exists"
    # AssertionError: 0 not greater than 0
    "test_skip_mapping_default"
  ];

  disabledTestPaths = [
    # Tests are pulling from external sources
    # https://github.com/bridgecrewio/checkov/blob/f03a4204d291cf47e3753a02a9b8c8d805bbd1be/.github/workflows/build.yml
    "integration_tests/"
    "tests/terraform/"
    # Performance tests have no value for us
    "performance_tests/test_checkov_performance.py"
    # Requires prettytable release which is only available in staging
    "tests/sca_package/"
    "tests/test_runner_filter.py"
  ];

  pythonImportsCheck = [
    "checkov"
  ];

  meta = with lib; {
    description = "Static code analysis tool for infrastructure-as-code";
    homepage = "https://github.com/bridgecrewio/checkov";
    longDescription = ''
      Prevent cloud misconfigurations during build-time for Terraform, Cloudformation,
      Kubernetes, Serverless framework and other infrastructure-as-code-languages.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ anhdle14 fab ];
  };
}
