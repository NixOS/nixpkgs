{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "devbox";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "jetpack-io";
    repo = pname;
    rev = version;
    hash = "sha256-Wm8IpXmxBm6Ifh7fV9viKAfIC8BdjN1prpUyeI9eNXE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetpack.io/devbox/internal/build.Version=${version}"
  ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-5uh1G+puVVG0A1d+R4pZfbv63zyB86ihBjzoT63Xf1s=";

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
