{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-E2wIXa/cYVY7vOq1PWKJHG1EVpgN8o6AxIi7KtwjsxI=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-js0dxnLBSnfhgjigTmQAh7D9t6ZeSHf7k6Xd3RIBUjo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = with lib; {
    description = "Instant, easy, predictable shells and containers";
    homepage = "https://www.jetpack.io/devbox";
    license = licenses.asl20;
    maintainers = with maintainers; [
      urandom
      lagoja
    ];
  };
}
