{ lib, buildGoModule, fetchFromGitHub, installShellFiles, packr, ... }:

buildGoModule rec {
  pname = "kubernetes-polaris";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    rev = version;
    sha256 = "sha256-K8iFoCUVfSQdPluEwsZlxww+llwwBP8qkFsFEkFZqlQ=";
  };

  vendorHash = "sha256-9hjJ7xyuviAsXHrgfzyqCnk6xh0fpQRP1KXi+CoskkI=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];

  preBuild = ''
    ${packr}/bin/packr2 -v --ignore-imports
  '';

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
    homepage = "https://www.fairwinds.com/polaris";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ longer ];
  };
}
