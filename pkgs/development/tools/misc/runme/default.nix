{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nodejs
, runtimeShell
, stdenv
, testers
, runme
}:

buildGoModule rec {
  pname = "runme";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "stateful";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-WsYaOaXaNGztVqHMURn/96lWA9grccoKw6AJOhqUdfQ=";
  };

  vendorHash = "sha256-5FMrz4I/i/uJDI4vK9hiet4zMRf0CSbc/YJAFi8hlEM=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    nodejs
  ];

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/stateful/runme/internal/version.BuildDate=1970-01-01T00:00:00Z"
    "-X=github.com/stateful/runme/internal/version.BuildVersion=${version}"
    "-X=github.com/stateful/runme/internal/version.Commit=${src.rev}"
  ];

  postPatch = ''
    substituteInPlace testdata/script/basic.txtar \
      --replace /bin/bash "${runtimeShell}"
  '';

  # version test assumes `ldflags` is unspecified
  preCheck = ''
    unset ldflags
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd runme \
      --bash <($out/bin/runme completion bash) \
      --fish <($out/bin/runme completion fish) \
      --zsh <($out/bin/runme completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = runme;
    };
  };

  meta = with lib; {
    description = "Execute commands inside your runbooks, docs, and READMEs";
    homepage = "https://runme.dev";
    changelog = "https://github.com/stateful/runme/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
