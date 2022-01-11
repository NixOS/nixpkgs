{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, installShellFiles, PCSC, pivKeySupport ? true, pkcs11Support ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WjYW9Fo27wE1pg/BqYsdHd8jwd8jG5bk37HmU1DqnyE=";
  };

  buildInputs = lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-6T98zu55BQ26e43a1i68rhebaLwY/iFM8CRqRcv2QwI=";

  excludedPackages = "\\(sample\\|webhook\\|help\\)";

  tags = [] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/pkg/version.GitVersion=v${version}" ];

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
