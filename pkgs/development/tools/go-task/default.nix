{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, go-task
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.27.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "refs/tags/v${version}";
    hash = "sha256-MwZtdxoWo5yeJKzbMIfigt0WUjZ52B8MeRsx43D8n1k=";
  };

  vendorHash = "sha256-05+/NbLks9Dp9Z7KscK9yeEzFJug7VFBqViievX6UOs=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/go-task/task/v3/internal/version.version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task

    installShellCompletion completion/{bash,fish,zsh}/*
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = go-task;
    };
  };

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
