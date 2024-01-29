{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    hash = "sha256-pXl0emLY+W0DkW4HONv3qVZzCEZnx/SX3MjyBajsosg=";
    fetchSubmodules = true;
  };

  subPackages = [ "." ];

  vendorHash = "sha256-nE+THN+Q7Ze36c0nd3oROoFPLIzH/kw9qBwMxv+j9uE=";

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
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
}
