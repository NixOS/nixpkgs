{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "simplotask";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    rev = "v${version}";
    hash = "sha256-ZPmYAUfkWo+inD2CwzT4Hncsshk3Y2W6aldy/5v1sks=";
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
    homepage = "https://simplotask.com/";
    maintainers = with maintainers; [ sikmir ];
    license = licenses.mit;
    mainProgram = "spot";
  };
}
