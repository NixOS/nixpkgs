{ lib
, python3
, fetchPypi
, nix-update-script
, testers
, aws-encryption-sdk-cli
}:

let
  localPython = python3.override {
    self = localPython;
    packageOverrides = final: prev: {
      urllib3 = prev.urllib3.overridePythonAttrs (prev: rec {
        pyproject = true;
        version = "1.26.18";
        nativeBuildInputs = with final; [ setuptools ];
        src = prev.src.override {
          inherit version;
          hash = "sha256-+OzBu6VmdBNFfFKauVW/jGe0XbeZ0VkGYmFxnjKFgKA=";
        };
      });
    };
  };
in

localPython.pkgs.buildPythonApplication rec {
  pname = "aws-encryption-sdk-cli";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OCbt0OkDVfpzUIogbsKzaPAle2L6l6N3cmZoS2hEaSM=";
  };

  build-system = with localPython.pkgs; [
    setuptools
  ];

  dependencies = with localPython.pkgs; [
    attrs
    aws-encryption-sdk
    base64io
    urllib3
    setuptools # for pkg_resources
  ];

  doCheck = true;

  nativeCheckInputs = with localPython.pkgs; [
    mock
    pytest-mock
    pytest7CheckHook
  ];

  disabledTestPaths = [
    # requires networking
    "test/integration"
  ];

  # Upstream did not adapt to pytest 8 yet.
  pytestFlagsArray = [ "-W" "ignore::pytest.PytestRemovedIn8Warning" ];

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
    license = licenses.asl20;
    mainProgram = "aws-encryption-cli";
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
