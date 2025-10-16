{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "devbox";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jetify-com";
    repo = "devbox";
    tag = finalAttrs.version;
    hash = "sha256-+OsFKBtc4UkkI37YJM9uKIJZC1+KkuDJJKjipRzyF7k=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetify.com/devbox/internal/build.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-0lDPK9InxoQzndmQvhKCYvqEt2NL2A+rt3sGg+o1HTY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = {
    description = "Instant, easy, predictable shells and containers";
    homepage = "https://www.jetify.com/devbox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      urandom
      lagoja
      madeddie
    ];
  };
})
