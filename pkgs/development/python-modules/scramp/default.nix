{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    sha256 = "15jb7z5l2lijxr60fb9v55i3f81h6d83c0b7fv5q0fv5q259nv0a";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scramp" ];

  meta = with lib; {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
