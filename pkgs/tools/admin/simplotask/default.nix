{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "simplotask";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    rev = "v${version}";
    hash = "sha256-bbn6RLkAAlQeHsaMmb34FFrhaYvouf8rSOJpGdYE7Y4=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s -w"
    "-X main.revision=v${version}"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/{secrets,spot-secrets}
    installManPage *.1
  '';

  meta = with lib; {
    description = "A tool for effortless deployment and configuration management";
    homepage = "https://spot.umputun.dev/";
    maintainers = with maintainers; [ sikmir ];
    license = licenses.mit;
    mainProgram = "spot";
  };
}
