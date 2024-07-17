{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "murex";
  version = "6.0.1000";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-biwwNuCUgBNV//4/PYKf/n4HA69uiBEYFWVwspI1GG8=";
  };

  vendorHash = "sha256-qOItRqCIxoHigufI6b7j2VdBDo50qGDe+LAaccgDh5w=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
  };
}
