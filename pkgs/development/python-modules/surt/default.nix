{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, tldextract
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "surt";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "surt";
    rev = "6934c321b3e2f66af9c001d882475949f00570c5"; # Has no git tag
    sha256 = "sha256-pSMNpFfq2V0ANWNFPcb1DwPHccbfddo9P4xZ+ghwbz4=";
  };

  propagatedBuildInputs = [
    six
    tldextract
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "surt" ];

  meta = with lib; {
    description = "Sort-friendly URI Reordering Transform (SURT) python module";
    homepage = "https://github.com/internetarchive/surt";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Luflosi ];
  };
}
