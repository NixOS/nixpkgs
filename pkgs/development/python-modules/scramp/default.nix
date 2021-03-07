{ lib
, asn1crypto
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    sha256 = "sha256-d/kfrhvU96eH8TQX7n1hVRclEFWLseEvOxiR6VaOdrg=";
  };

  propagatedBuildInputs = [ asn1crypto ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scramp" ];

  meta = with lib; {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
