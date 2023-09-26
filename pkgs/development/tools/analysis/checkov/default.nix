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
  pname = "checkov";
  version = "2.4.48";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-d9rSzdsKnbL7yBLweptGzq40wn15I1PB1YQFa7/GJKU=";
  };

  patches = [
    ./flake8-compat-5.x.patch
  ];

  pythonRelaxDeps = [
    "bc-detect-secrets"
    "bc-python-hcl2"
    "dpath"
    "license-expression"
    "networkx"
    "pycep-parser"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    aiomultiprocess
    argcomplete
    bc-detect-secrets
    bc-jsonpath-ng
    bc-python-hcl2
    boto3
    cachetools
    charset-normalizer
    cloudsplaining
    colorama
    configargparse
    cyclonedx-python-lib
    deep_merge
    docker
    dockerfile-parse
    dpath
    flake8
    gitpython
    igraph
    jmespath
    jsonschema
    junit-xml
    license-expression
    networkx
    openai
    packaging
    policyuniverse
    prettytable
    pycep-parser
    pyyaml
    semantic-version
    spdx-tools
    tabulate
    termcolor
    tqdm
    typing-extensions
    update_checker
  ];

  nativeCheckInputs = [
    aioresponses
    mock
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # No API key available
    "api_key"
    # Requires network access
    "TestSarifReport"
    "test_skip_mapping_default"
    # Flake8 test
    "test_file_with_class"
    "test_dataclass_skip"
    "test_typing_class_skip"
    # Tests are comparing console output
    "cli"
    "console"
    # Starting to fail after 2.3.205
    "test_non_multiline_pair"
    "test_secret_value_in_keyword"
    "test_runner_verify_secrets_skip_invalid_suppressed"
    "test_runner_verify_secrets_skip_all_no_effect"
    "test_runner"
  ];

  disabledTestPaths = [
    # Tests are pulling from external sources
    # https://github.com/bridgecrewio/checkov/blob/f03a4204d291cf47e3753a02a9b8c8d805bbd1be/.github/workflows/build.yml
    "integration_tests/"
    "tests/ansible/"
    "tests/arm/"
    "tests/bicep/"
    "tests/cloudformation/"
    "tests/common/"
    "tests/dockerfile/"
    "tests/generic_json/"
    "tests/generic_yaml/"
    "tests/github_actions/"
    "tests/github/"
    "tests/kubernetes/"
    "tests/sca_package_2"
    "tests/terraform/"
    # Performance tests have no value for us
    "performance_tests/test_checkov_performance.py"
    # No Helm
    "dogfood_tests/test_checkov_dogfood.py"
  ];

  pythonImportsCheck = [
    "checkov"
  ];

  postInstall = ''
    chmod +x $out/bin/checkov
  '';

  meta = with lib; {
    description = "Static code analysis tool for infrastructure-as-code";
    homepage = "https://github.com/bridgecrewio/checkov";
    changelog = "https://github.com/bridgecrewio/checkov/releases/tag/${version}";
    longDescription = ''
      Prevent cloud misconfigurations during build-time for Terraform, Cloudformation,
      Kubernetes, Serverless framework and other infrastructure-as-code-languages.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ anhdle14 fab ];
  };
}
