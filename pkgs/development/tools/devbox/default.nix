{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-iaPdFDoYmukv1T+HSaGRrbvjvkioX5PlCc9t2VHGJ30=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-bSCgjSXdPOWgftlInl3MailtiXslLH/TZw95FiEnCxQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = with lib; {
    description = "Instant, easy, predictable shells and containers.";
    homepage = "https://www.jetpack.io/devbox";
    license = licenses.asl20;
    maintainers = with maintainers; [
      urandom
      lagoja
    ];
  };
}
