{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vt-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-NB5eo+6IwIxhQX1lwJzPOZ0pSeFVo7LYIEEmDqE4A7Y=";
  };

  vendorHash = "sha256-s90a35fFHO8Tt7Zjf9bk1VVD2xhG1g4rKmtIuMl0bMQ=";

  ldflags = [
    "-X github.com/VirusTotal/vt-cli/cmd.Version=${version}"
  ];

  subPackages = [ "vt" ];

  meta = with lib; {
    description = "VirusTotal Command Line Interface";
    homepage = "https://github.com/VirusTotal/vt-cli";
    changelog = "https://github.com/VirusTotal/vt-cli/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "vt";
    maintainers = with maintainers; [ dit7ya ];
  };
}
