{ lib
, asn1crypto
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    sha256 = "sha256-aXuRIW/3qBzan8z3EzSSxqaZfa3WnPhlviNa2ugIjik=";
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
