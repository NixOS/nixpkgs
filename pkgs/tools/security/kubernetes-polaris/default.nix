{ lib, buildGo120Module, fetchFromGitHub, installShellFiles, ... }:

buildGo120Module rec {
  pname = "kubernetes-polaris";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    rev = version;
    sha256 = "sha256-eRcgt1ZRiTgqfqiRFQ4f4ydsvU39UdbIQ4yKtiRUpn4=";
  };

  vendorHash = "sha256-txrTmkOqcwBN2vmlSOjHuPwavAWXxQylRxWZC3i90ck=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd polaris \
      --bash <($out/bin/polaris completion bash) \
      --fish <($out/bin/polaris completion fish) \
      --zsh <($out/bin/polaris completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/polaris help
    $out/bin/polaris version | grep 'Polaris version:${version}'

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Validate and remediate Kubernetes resources to ensure configuration best practices are followed";
    mainProgram = "polaris";
    homepage = "https://www.fairwinds.com/polaris";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ longer ];
  };
}
