{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nodejs
, python3
, runtimeShell
, stdenv
, testers
, runme
}:

buildGoModule rec {
  pname = "runme";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "stateful";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-a+7Gff3Z1V17uaywoUE+nLVeVprB50Gslarcle/NPB8=";
  };

  vendorHash = "sha256-QoZzEq1aC7cjY/RVp5Z5HhSuTFf2BSYQnfg0jSaeTJU=";

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

  # tests fail to access /etc/bashrc on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    substituteInPlace testdata/{categories/basic,runall/basic,script/basic}.txtar \
      --replace /bin/bash "${runtimeShell}"
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
    mainProgram = "runme";
    homepage = "https://runme.dev";
    changelog = "https://github.com/stateful/runme/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
