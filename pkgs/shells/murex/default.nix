{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "5.3.4000";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cShXZa3ms7RmnRrvWyvijWF7kTO7K6GS1IvEUyT2mio=";
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
