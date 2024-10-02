{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubernetes-polaris";
  version = "9.4.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    rev = version;
    sha256 = "sha256-CVc/ZMF/3HBDPjny81Pj26eSnBuTRjXgkso34kZSex4=";
  };

  vendorHash = "sha256-X0GPKR6l1v5312hOmelrcqp4KT3LwsGkvKoqUfEM0uU=";

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
