{ lib
, python3
, fetchFromGitHub
, git
, testers
, aws-sam-cli
, nix-update-script
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.103.0";
  format = "pyproject";

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sam-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-oy0+dAA6x8Jl1nZ1wjsR9xvpR9biemTtqL9B1awz4BM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "aws-sam-translator"
    "boto3-stubs"
    "tzlocal"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aws-lambda-builders
    aws-sam-translator
    boto3
    boto3-stubs
    cfn-lint
    chevron
    click
    cookiecutter
    dateparser
    docker
    flask
    jsonschema
    pyopenssl
    pyyaml
    requests
    rich
    ruamel-yaml
    tomlkit
    typing-extensions
    tzlocal
    watchdog
  ] ++ (with python3.pkgs.boto3-stubs.optional-dependencies; [
    apigateway
    cloudformation
    ecr
    iam
    kinesis
    lambda
    s3
    schemas
    secretsmanager
    signer
    sqs
    stepfunctions
    sts
    xray
  ]);

  postFixup = ''
    # Disable telemetry: https://github.com/aws/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam \
      --set SAM_CLI_TELEMETRY ${if enableTelemetry then "1" else "0"} \
      --prefix PATH : $out/bin:${lib.makeBinPath [ git ]}
  '';

  doCheck = true;

  nativeCheckInputs = with python3.pkgs; [
    filelock
    flaky
    parameterized
    psutil
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin:${lib.makeBinPath [ git ]}"
  '';

  pytestFlagsArray = [
    "tests"

    # Disable tests that requires networking or complex setup
    "--ignore=tests/end_to_end"
    "--ignore=tests/integration"
    "--ignore=tests/regression"
    "--ignore=tests/smoke"
    "--ignore=tests/unit/lib/telemetry"

    # Disable flaky tests
    "--ignore=tests/unit/lib/samconfig/test_samconfig.py"
    "--deselect=tests/unit/lib/sync/flows/test_rest_api_sync_flow.py::TestRestApiSyncFlow::test_update_stage"
    "--deselect=tests/unit/lib/sync/flows/test_rest_api_sync_flow.py::TestRestApiSyncFlow::test_delete_deployment"
    "--deselect=tests/unit/local/lambda_service/test_local_lambda_invoke_service.py::TestValidateRequestHandling::test_request_with_no_data"

    # Disable warnings
    "-W ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "samcli"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = aws-sam-cli;
      command = "sam --version";
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "^v([0-9.]+)$" ];
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "CLI tool for local development and testing of Serverless applications";
    homepage = "https://github.com/aws/aws-sam-cli";
    changelog = "https://github.com/aws/aws-sam-cli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "sam";
    maintainers = with maintainers; [ lo1tuma anthonyroussel ];
  };
}
