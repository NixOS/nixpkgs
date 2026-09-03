{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
  tldextract,
}:

buildPythonPackage {
  pname = "surt";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "surt";
    # Has no git tag, https://github.com/internetarchive/surt/issues/26
    # nixpkgs-update: no auto update
    rev = "6934c321b3e2f66af9c001d882475949f00570c5";
    hash = "sha256-pSMNpFfq2V0ANWNFPcb1DwPHccbfddo9P4xZ+ghwbz4=";
  };

  propagatedBuildInputs = [
    six
    tldextract
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "surt" ];

  disabledTests = [
    # Tests want to download Public Suffix List
    "test_getPublicPrefix"
    "test_getPublicSuffix"
  ];

  meta = {
    description = "Sort-friendly URI Reordering Transform (SURT) python module";
    homepage = "https://github.com/internetarchive/surt";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
