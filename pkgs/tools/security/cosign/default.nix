{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, installShellFiles, PCSC, pivKeySupport ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VKlM+bsK2Oj0UB4LF10pHEIJqXv6cAO5rtxnTogpfOk=";
  };

  buildInputs = lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-idMvvYeP5rAT6r9RPZ9S8K9KTpVYVq06ZKSBPxWA2ms=";

  excludedPackages = "\\(sample\\|webhook\\|help\\)";

  tags = lib.optionals pivKeySupport [ "pivkey" ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/cmd/cosign/cli/options.GitVersion=v${version}" ];

  postInstall = ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
