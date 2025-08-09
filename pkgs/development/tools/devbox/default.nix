{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "jetify-com";
    repo = pname;
    rev = version;
    hash = "sha256-LAYGjpaHxlolzzpilD3DOvd+J0eNJ0p+VdRayGQvUWo=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetify.com/devbox/internal/build.Version=${version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-cBRdJUviqtzX1W85/rZr23W51mdjoEPCwXxF754Dhqw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = with lib; {
    description = "Instant, easy, predictable shells and containers";
    homepage = "https://www.jetify.com/devbox";
    license = licenses.asl20;
    maintainers = with maintainers; [
      urandom
      lagoja
      madeddie
    ];
  };
}
