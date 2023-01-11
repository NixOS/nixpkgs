{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "go-task";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "v${version}";
    sha256 = "sha256-MtbgFx/+SVBcV6Yp1WEwKLQGx5oPxvqljtXeyUYNS+I=";
  };

  vendorHash = "sha256-AZtkWJ/U1dH9J+wowlcg25qBVyRRo6LCzc6IBYKBkVA=";

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
