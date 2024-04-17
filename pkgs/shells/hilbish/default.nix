{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    hash = "sha256-tkEEvxIBPpPbdIFxbo0pOHHORXEFZ8wn9emIeyz6glc=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-jf+S1On3Cib20Uepsm8WeRwEyuRKzSPFfsT2YVkx4fs=";

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
    mainProgram = "hilbish";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
}
