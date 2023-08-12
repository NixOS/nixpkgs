{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, pcsclite
, pkg-config
, installShellFiles
, PCSC
, pivKeySupport ? true
, pkcs11Support ? true
, testers
, cosign
}:
buildGoModule rec {
  pname = "cosign";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5dRrq+mV2fDGTi2WZHlCP8+GH3cBJIE8AHGuch7hv/I=";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  vendorHash = "sha256-y9bUwyQMYw4m7JZ6RpTlcYZOiCoxaQRiWYKNmgzEXJA=";

  subPackages = [
    "cmd/cosign"
  ];

  tags = [ ] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # test all paths
    unset subPackages

    rm pkg/cosign/ctlog_test.go # Require network access
    rm pkg/cosign/tlog_test.go # Require network access
    rm cmd/cosign/cli/verify/verify_blob_attestation_test.go # Require network access
  '';

  postInstall = ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = cosign;
    command = "cosign version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk developer-guy ];
  };
}
