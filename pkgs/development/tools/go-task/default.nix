{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "go-task";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-J/pWx/osqP29GERBdzWwPNeA4Rzo6CYdW7GrmspevwM=";
  };

  vendorSha256 = "sha256-NlQ/5ibRgmuGDcuiUdzvuexYGnR/34v9fw1DUe3yXxE=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task

    installShellCompletion completion/{bash,fish,zsh}/*
  '';

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
