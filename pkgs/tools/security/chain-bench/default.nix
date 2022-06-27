{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chain-bench";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3cIJQ6MmdcC4u0AT8aBQtt0wko3af5Xm9xGE3k4mCIE=";
  };
  vendorSha256 = "sha256-FBc1H5L458jPz+G4MlB8gMGkfaR+x1AZ6tmCVr2hMk8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd chain-bench \
      --bash <($out/bin/chain-bench completion bash) \
      --fish <($out/bin/chain-bench completion fish) \
      --zsh <($out/bin/chain-bench completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/chain-bench --help
    $out/bin/chain-bench --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/chain-bench";
    changelog = "https://github.com/aquasecurity/chain-bench/releases/tag/v${version}";
    description = "An open-source tool for auditing your software supply chain stack for security compliance based on a new CIS Software Supply Chain benchmark";
    longDescription = ''
      Chain-bench is an open-source tool for auditing your software supply chain
      stack for security compliance based on a new CIS Software Supply Chain
      benchmark. The auditing focuses on the entire SDLC process, where it can
      reveal risks from code time into deploy time. To win the race against
      hackers and protect your sensitive data and customer trust, you need to
      ensure your code is compliant with your organization's policies.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    # TODO: see if this is an issue
    # # Need updated macOS SDK
    # # https://github.com/NixOS/nixpkgs/issues/101229
    # broken = (stdenv.isDarwin && stdenv.isx86_64);
  };
}
