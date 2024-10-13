{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitleaks,
  installShellFiles,
  testers,
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.20.1";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = "gitleaks";
    rev = "refs/tags/v${version}";
    hash = "sha256-oIhA1+gicNXDHzpdVzFeDvJHGCrqBhwyV+KOyYwMaK8=";
  };

  vendorHash = "sha256-4bGpTMmQmsJQ2RNIehYe0xAwwGOh2l6FGsKdciEVLAc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # With v8 the config tests are blocking
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = gitleaks;
    command = "${pname} version";
  };

  meta = with lib; {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/zricethezav/gitleaks";
    changelog = "https://github.com/zricethezav/gitleaks/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "gitleaks";
  };
}
