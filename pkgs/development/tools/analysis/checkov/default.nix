{ lib
, fetchFromGitHub
, python3
}:
let
  py = python3.override {
    packageOverrides = self: super: {

      boto3 = super.boto3.overridePythonAttrs (oldAttrs: rec {
        version = "1.17.112";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1byqrffbgpp1mq62gnn3w3hnm54dfar0cwgvmkl7mrgbwz5xmdh8";
        };
      });

      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "1.20.112";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1ksdjh3mwbzgqgfj58vyrhann23b9gqam8id2svmpdmmdq5vgffh";
        };
      });

      s3transfer = super.s3transfer.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1cp169vz9rvng7dwbn33fgdbl3b014zpsdqsnfxxw7jm2r5jy0nb";
        };
      });

      dpath = super.dpath.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "06rn91n2izw7czncgql71w7acsa8wwni51njw0c6s8w4xas1arj9";
        };
        doCheck = false;
      });

    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "checkov";
  version = "2.0.509";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = version;
    sha256 = "sha256-dds01scC93d/WdQTTL/JvXvfbiFAF3nEESL/zdFpOYA=";
  };

  nativeBuildInputs = with py.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with py.pkgs; [
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
    junit-xml
    networkx
    packaging
    policyuniverse
    pyyaml
    semantic-version
    tabulate
    termcolor
    tqdm
    typing-extensions
    update_checker
  ];

  checkInputs = with py.pkgs; [
    jsonschema
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # No API key available
    "api_key"
    # Requires network access
    "TestSarifReport"
  ];

  disabledTestPaths = [
    # Tests are pulling from external sources
    # https://github.com/bridgecrewio/checkov/blob/f03a4204d291cf47e3753a02a9b8c8d805bbd1be/.github/workflows/build.yml
    "integration_tests/"
    "tests/terraform/"
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
    maintainers = with maintainers; [ anhdle14 ];
  };
}
