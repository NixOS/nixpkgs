{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-p/b+s5/5Q58qYTfZwN6qHpMzgJ2ErUEP/FLB1oDXN8g=";
  };

  vendorHash = "sha256-Fmfr9feTibAjiZaakJalGTS7X2RhGz6engMNhy48Zus=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    mainProgram = "cloud-nuke";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
