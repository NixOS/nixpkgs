{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "girsh";
  version = "0.41";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Girsh";
    rev = "refs/tags/v${version}";
    hash = "sha256-MgzIBag0Exoh0TXW/AD0lbSOj7PVkMeVYQ8v5jdCgAs=";
  };

  vendorHash = "sha256-8NPFohguMX/X1khEPF+noLBNe/MUoPpXS2PN6SiotL8=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Automatically spawn a reverse shell fully interactive for Linux or Windows victim";
    homepage = "https://github.com/nodauf/Girsh";
    changelog = "https://github.com/nodauf/Girsh/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
