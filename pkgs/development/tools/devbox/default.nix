{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-Xs7xd2U00AnYlXZv1PYHaSIYhDg+GpCHAtT2xis61vM=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-Ct1hftgMYAF8DPdnYTB1QQYD0HGC4wifIbMX+TrgDdk=";

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
    maintainers = with maintainers; [ urandom ];
  };
}
