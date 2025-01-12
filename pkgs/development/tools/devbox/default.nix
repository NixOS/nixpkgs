{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-D56yT/A3aT9k6uEJv8NYEeHjjKzNiXMveLoOlQSjDKU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-xsx+bFjvYpLYE+Sok+4zlsK6i9QLg04fdWQoN5zC2CY=";

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
