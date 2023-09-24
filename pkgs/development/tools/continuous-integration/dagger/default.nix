{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-vlHLqqUMZAuBgI5D1L2g6u3PDZsUp5oUez4x9ydOUtM=";
  };

  vendorHash = "sha256-B8Qvyvh9MRGFDBvc/Hu+IitBBdHvEU3QjLJuIy1S04A=";
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X github.com/dagger/dagger/engine.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dagger \
      --bash <($out/bin/dagger completion bash) \
      --fish <($out/bin/dagger completion fish) \
      --zsh <($out/bin/dagger completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = dagger;
    command = "dagger version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}
