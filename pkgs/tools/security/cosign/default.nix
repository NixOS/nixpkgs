{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config
, installShellFiles, PCSC, pivKeySupport ? true, pkcs11Support ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K9ZORbccEH7KV0XHkio/fl/5kvUInRCvzFY4QOqrgfg=";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-958HDdd9o+paEHVvwWSFJGSIHuY63jf89rTw3QKJzxc=";

  excludedPackages = "\\(sample\\|webhook\\|help\\)";

  tags = [ ] ++ lib.optionals pivKeySupport [ "pivkey" ]
    ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sigstore/cosign/pkg/version.GitVersion=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description =
      "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
