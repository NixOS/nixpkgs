{ lib
, buildGo121Module
, fetchFromGitHub
, installShellFiles
, nodejs
, python3
, runtimeShell
, stdenv
, testers
, runme
}:

buildGo121Module rec {
  pname = "runme";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "stateful";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-ZM8gdZ26XAlC+j6U0+oQJIb+5gOGFUAYHPP82kA1ogU=";
  };

  vendorHash = "sha256-nKH4hT0J9QfrDdvovu/XNxU4PtZYKkfqEBiCTNLWyRA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    nodejs
    python3
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
