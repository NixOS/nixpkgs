{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, go-task
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "refs/tags/v${version}";
    hash = "sha256-XeybiKK0VywVqRqJgnp2+ZwgqwgBDVM9wcB5Md5pzM0=";
  };

  vendorHash = "sha256-irXCHPKQFcq2C84n9aFjKnV9f8AzBrIuuV1BkTrDK4s=";

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
