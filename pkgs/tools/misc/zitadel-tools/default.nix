{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "zitadel-tools";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel-tools";
    rev = "v${version}";
    hash = "sha256-r9GEHpfDlpK98/dnsxjhUgWKn6vHQla8Z+jQUVrHGyo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-y2PYj0XRSgfiaYpeqAh4VR/+NKUPKd1c0w9pPCWsUrY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    local INSTALL="$out/bin/zitadel-tools"
    installShellCompletion --cmd zitadel-tools \
      --bash <($out/bin/zitadel-tools completion bash) \
      --fish <($out/bin/zitadel-tools completion fish) \
      --zsh <($out/bin/zitadel-tools completion zsh)
  '';

  meta = with lib; {
    description = "Helper tools for zitadel";
    homepage = "https://github.com/zitadel/zitadel-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
    mainProgram = "zitadel-tools";
  };
}
