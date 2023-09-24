{ lib
, python3Packages
, fetchPypi
, nix-update-script
, testers
, aws-encryption-sdk-cli
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-encryption-sdk-cli";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OCbt0OkDVfpzUIogbsKzaPAle2L6l6N3cmZoS2hEaSM=";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs
    aws-encryption-sdk
    base64io
  ];

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    mock
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires networking
    "test/integration"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = aws-encryption-sdk-cli;
      command = "aws-encryption-cli --version";
    };
  };

  meta = with lib; {
    homepage = "https://aws-encryption-sdk-cli.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-cli/blob/v${version}/CHANGELOG.rst";
    description = "CLI wrapper around aws-encryption-sdk-python";
    license = licenses.apsl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
