<<<<<<< HEAD
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
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "go-task";
  version = "3.24.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-RzXJCYiIxbSgXuUinS5ixKCobZtMx5MM/ilzSPzTdsI=";
  };

  vendorHash = "sha256-+8nLU2mg7fiWSRu0w9ZMd5KvyFyYbNO1tyJpZASdc2c=";
=======
    hash = "sha256-8YkhdMJJ4EgFqkBOSudpznEKRe9bsd/yR2NuvJcrfgY=";
  };

  vendorHash = "sha256-iHze5mcXDmOyTxqQX5/HtElDY0Af3bTbB6xLrZjVHPY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
<<<<<<< HEAD
    "-s"
    "-w"
    "-X=github.com/go-task/task/v3/internal/version.version=${version}"
=======
    "-s" "-w" "-X main.version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task

    installShellCompletion completion/{bash,fish,zsh}/*
  '';

<<<<<<< HEAD
  passthru.tests = {
    version = testers.testVersion {
      package = go-task;
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "A task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
