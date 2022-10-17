{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, installShellFiles, PCSC, pivKeySupport ? true, pkcs11Support ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EZHT6Ut7fI9Sx7U664r4ZvzZCH1hu9acnGvUyn8XgSw=";
  };

  buildInputs = lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorSha256 = "sha256-9XRORuHx4bZn9odMD+prg/dPBkUmVqBNQYjQGCQVqiw=";

  subPackages = [
    "cmd/cosign"
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
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
