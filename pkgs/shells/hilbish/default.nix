{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    hash = "sha256-OEuriFnVDS0POXoPeUk4IcLtV3JAMLDM2apDxmjg5cQ=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Kiy1JR3X++naY2XNLpnGujrNQt7qlL0zxv8E96cHmHo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.dataDir=${placeholder "out"}/share/hilbish"
  ];

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish/
    cp -r libs -t $out/share/hilbish/
    cp -r nature $out/share/hilbish/
  '';

  meta = with lib; {
    description = "An interactive Unix-like shell written in Go";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ fortuneteller2k ];
    license = licenses.mit;
  };
}
