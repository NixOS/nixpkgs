{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, installShellFiles, PCSC, pivKeySupport ? true, pkcs11Support ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TfPxLSUVs/b9krexTa1wzBkaUAL8xggfpJOlxdHLzjA=";
  };

  buildInputs = lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-gL5VCFcKz+hrwJ+KZifgBtgrgpKcBbvE4mFAg0LnOgc=";

  subPackages = [
    "cmd/cosign"
    "cmd/sget"
  ];

  tags = [] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  preCheck = ''
    # test all paths
    unset subPackages

    rm pkg/cosign/tlog_test.go # Require network access
    rm pkg/cosign/verify_test.go # Require network access
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
