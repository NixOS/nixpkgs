{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-5GPJVusF3/WbEE5VH45Wyxq40wbNxgjO8QI2cLMpdN0=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-Kiy1JR3X++naY2XNLpnGujrNQt7qlL0zxv8E96cHmHo=";

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
