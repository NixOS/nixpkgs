{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.32.1";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-+zSUgwh3CKyvBzRY4NevkoSINfvMNOfw8rvs48O0yJw=";
  };

  vendorHash = "sha256-iEPBTM+hVAGs0TF30onHR0lWAALQbsA164OTkYuOdwc=";

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
    "-X main.Version=${version}"
    "-X main.GitCommit=ref/tags/${version}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=unknown"
  ];

  doCheck = true;

  # Some tests require access to scaleway's API, failing when sandboxed
  preCheck = ''
    substituteInPlace internal/core/bootstrap_test.go \
      --replace "TestInterruptError" "SkipInterruptError"
    substituteInPlace internal/e2e/errors_test.go \
      --replace "TestStandardErrors" "SkipStandardErrors"
    substituteInPlace internal/e2e/human_test.go \
      --replace "TestTestCommand" "SkipTestCommand" \
      --replace "TestHumanCreate" "SkipHumanCreate" \
      --replace "TestHumanList" "SkipHumanList" \
      --replace "TestHumanUpdate" "SkipHumanUpdate" \
      --replace "TestHumanGet" "SkipHumanGet" \
      --replace "TestHumanDelete" "SkipHumanDelete"
    substituteInPlace internal/e2e/sdk_errors_test.go \
      --replace "TestSdkStandardErrors" "SkipSdkStandardErrors"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/scw --help

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      nickhu
      techknowlogick
      kashw2
    ];
  };
}
