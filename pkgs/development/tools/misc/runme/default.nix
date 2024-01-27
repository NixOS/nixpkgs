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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "stateful";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-6V7OxWJ0EYcbaHmls0P9iJD9tQ9N4GSPzBAKVdShvXg=";
  };

  vendorHash = "sha256-PLDsea/o067ifiX0RKFC7gDpORLVEQ0DV6sdBzzQCTs=";

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
  doCheck = !stdenv.isDarwin;

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
    homepage = "https://runme.dev";
    changelog = "https://github.com/stateful/runme/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
