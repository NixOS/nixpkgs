{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fulcio";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MvLQMGPyJYqYUljLqsr+qJeeYnxdH9aNGkWpDRvOeh8=";
  };
  vendorSha256 = "sha256-pRL0et+UOi/tzuQz/Q7UmSA+pVhLJYR8lG8NAbPN9PU=";

  ldflags = [ "-s" "-w" ];

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/fulcio $out/bin/fulcio-server
    installShellCompletion --cmd fulcio-server \
      --bash <($out/bin/fulcio-server completion bash) \
      --fish <($out/bin/fulcio-server completion fish) \
      --zsh <($out/bin/fulcio-server completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/fulcio-server --help
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/fulcio";
    changelog = "https://github.com/sigstore/fulcio/releases/tag/v${version}";
    description = "A Root-CA for code signing certs - issuing certificates based on an OIDC email address";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
