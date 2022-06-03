{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "go-task";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-N/xx5gATuLrHcWnMXgFMmz3wbFtaHsiPfDaNhdTbk5c=";
  };

  vendorSha256 = "sha256-73DtLYyq3sltzv4VtZMlZaSbP9zA9RZw2wgXVkzwrso=";

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
