{ lib
, buildGoModule
, fetchFromGitHub
, gitleaks
, installShellFiles
, testers
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.16.3";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WukTYi7iqagOLpx8KATEittlM6OvIfxDYiNTdsotjTY=";
  };

  vendorHash = "sha256-Ev0/CSpwJDmc+Dvu/bFDzsgsq80rWImJWXNAUqYHgoE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zricethezav/gitleaks/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # With v8 the config tests are are blocking
  doCheck = false;

  postInstall = ''
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
  };
}
