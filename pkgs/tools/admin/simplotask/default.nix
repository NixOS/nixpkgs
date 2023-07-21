{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "simplotask";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    rev = "v${version}";
    hash = "sha256-8QlxZ41t7tbi1Z5wjEp6BcjgVFoywM5T5PQGlImZWMk=";
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
