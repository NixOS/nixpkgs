{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, go-task
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.38.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "task";
    rev = "refs/tags/v${version}";
    hash = "sha256-mz/07DONaO3kCxOXEnvWglY0b9JXxCXjTrVIEbsbl98=";
  };

  vendorHash = "sha256-2M/FrXip0Tz0wguCd81qbBDW3XIJlAWwVzD+hIFm6sw=";

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
    description = "Task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}
