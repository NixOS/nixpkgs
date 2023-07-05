{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "bloodhound-python";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "BloodHound.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-K74VntcRcIgKu48JhLuWeFcqPQg7vurd0+H1e6Kk3Rg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
    dnspython
  ];

  doCheck = false;

  meta = with lib; {
      description = "Python based ingestor for BloodHound, based on Impacket.";
      homepage = "https://github.com/fox-it/BloodHound.py";
      platforms = [ "x86_64-linux" ]; 
      license = licenses.mit;
      maintainers = with maintainers; [ exploitoverload ];
    };
}
