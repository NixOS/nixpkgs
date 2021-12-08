{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "zipstream";
  version = "1.1.4";

  src = fetchFromGitHub {
     owner = "allanlei";
     repo = "python-zipstream";
     rev = "v1.1.4";
     sha256 = "0ymcz7q0mmj44blhzxvbhphy1psmgrf4ik1q1cnqnmrg9wylc7g4";
  };

  checkInputs = [ nose ];

  meta = {
    description = "A zip archive generator";
    homepage = "https://github.com/allanlei/python-zipstream";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
