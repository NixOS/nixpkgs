{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, go-task
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.29.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "refs/tags/v${version}";
    hash = "sha256-RzXJCYiIxbSgXuUinS5ixKCobZtMx5MM/ilzSPzTdsI=";
  };

  vendorHash = "sha256-+8nLU2mg7fiWSRu0w9ZMd5KvyFyYbNO1tyJpZASdc2c=";

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
