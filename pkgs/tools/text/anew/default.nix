{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "anew";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "anew";
    rev = "v${version}";
    hash = "sha256-NQSs99/2GPOtXkO7k+ar16G4Ecu4CPGMd/CTwEhcyto=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tool for adding new lines to files, skipping duplicates";
    homepage = "https://github.com/tomnomnom/anew";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
