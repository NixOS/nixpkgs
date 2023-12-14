{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "5.2.7610";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YyMt1V9Utar849+HPGLGJc25PvV7Q2pJehpFOOxlraY=";
  };

  vendorHash = "sha256-qOItRqCIxoHigufI6b7j2VdBDo50qGDe+LAaccgDh5w=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
