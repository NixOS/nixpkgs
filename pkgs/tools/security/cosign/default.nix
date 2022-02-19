{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, installShellFiles, PCSC, pivKeySupport ? true, pkcs11Support ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-37jahAGgQn7HwwdRTlAS/oJQ3BxTkMViI6iJMBYFgjI=";
  };

  buildInputs = lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-d3aOX4iMlhlxgYbqCHCIFKXunVha0Fw4ZBmy4OA6EhI=";

  excludedPackages = "\\(sample\\|webhook\\|help\\)";

  tags = [] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/pkg/version.GitVersion=v${version}" ];

  postPatch = ''
    rm pkg/cosign/tuf/client_test.go # Require network access
    rm internal/pkg/cosign/fulcio/signer_test.go # Require network access
    rm internal/pkg/cosign/rekor/signer_test.go # Require network access
    rm pkg/cosign/kubernetes/webhook/validator_test.go # Require network access
  '';

  postInstall = ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
    installShellCompletion --cmd sget \
      --bash <($out/bin/sget completion bash) \
      --fish <($out/bin/sget completion fish) \
      --zsh <($out/bin/sget completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
