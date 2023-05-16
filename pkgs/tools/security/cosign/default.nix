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
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VE/rm85KZs3JWMsidIlUGJ9JrtZ4VBI+Go1yujq7z1s=";
=======
    hash = "sha256-jJHLCN9hEQy4ijFm6g2E9WvTT43kvPhdRW1aczvEcFs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

<<<<<<< HEAD
  vendorHash = "sha256-mpT4/BS/NofMueBbwhh4v6pNEONEpWM9RDKuYZ+9BtA=";
=======
  vendorHash = "sha256-X5CY8U3IgxWD3zpb1f9R9Xk/25x1zxfYXkvXbelFBQc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
