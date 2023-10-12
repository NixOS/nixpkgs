{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    hash = "sha256-EHAQRmBgQEM0ypfUwuaoPnoKsQb1S+tarO1nHdmY5RI=";
  };

  vendorHash = "sha256-fUNet9P6twEJP4eYooiHZ6qaJ3jEkJUwQ2zPzk3+eIs=";
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
