{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # fix version resolution when passed in though ldflags
    # remove on next release
    (fetchpatch {
      name = "fix-ldflags-version.patch";
      url = "https://github.com/go-task/task/commit/9ee4f21d62382714ac829df6f9bbf1637406eb5b.patch?full_index=1";
      hash = "sha256-wu5//aZ/vzuObb03AjUUlVFjPr175mn1vVAZgqSGIZ0=";
    })
  ];

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

    substituteInPlace $out/share/bash-completion/completions/task.bash \
      --replace-fail 'complete -F _task task' 'complete -F _task task go-task'
    substituteInPlace $out/share/fish/vendor_completions.d/task.fish \
      --replace-fail 'complete -c $GO_TASK_PROGNAME' 'complete -c $GO_TASK_PROGNAME -c go-task'
    substituteInPlace $out/share/zsh/site-functions/_task \
      --replace-fail '#compdef task' '#compdef task go-task'
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
