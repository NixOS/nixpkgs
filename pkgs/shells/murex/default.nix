{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "2.11.2200";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nyrZttTOWpr7rBc2Ks04cWMGZFmd7lVIz6mHa0m+dDE=";
  };

  vendorSha256 = "sha256-hLz36ESf6To6sT/ha/yXyhG0U1gGw8HDfnrPJnws25g=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
