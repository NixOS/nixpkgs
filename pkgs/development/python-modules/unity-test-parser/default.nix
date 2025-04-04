{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  junit-xml,
  approvaltests,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "unity-test-parser";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ETCLabs";
    repo = "unity-test-parser";
    tag = "v${version}";
    hash = "sha256-x5kbNvQn1RxGaHGnXWKAkaBfwCpGW7lHlkHaYRGqCyE=";
  };

  patches = [
    # https://github.com/ETCLabs/unity-test-parser/pull/4
    (fetchpatch {
      url = "https://github.com/ETCLabs/unity-test-parser/commit/7f0a7bcacdffd1b89c7c87bc1be3e37482344d21.patch";
      hash = "sha256-IWGSXFj+ZtAz9X6KTMuZ670m/2WifQfSCi5jqxegP6s=";
    })

    # https://github.com/ETCLabs/unity-test-parser/pull/5
    (fetchpatch {
      url = "https://github.com/ETCLabs/unity-test-parser/commit/6ac6de19ccd7e42d0da1a7b05031528fd1491e57.patch";
      hash = "sha256-3xAuKRJyJgzVdzIIosFW5DnAczdGcxM3il5uLsvzyfs=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ junit-xml ];

  nativeCheckInputs = [
    approvaltests
    pytestCheckHook
  ];

  pythonImportsCheck = [ "unity_test_parser" ];

  meta = {
    description = "Unity test parser written in Python";
    homepage = "https://github.com/ETCLabs/unity-test-parser";
    changelog = "https://github.com/ETCLabs/unity-test-parser/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ concatime ];
  };
}
