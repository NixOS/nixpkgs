{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fulcio";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = version;
    sha256 = "sha256-+HWzhg+LTKpr9VJ9mzQghwOuGgp3EBb4/zltaqp0zHw=";
  };
  vendorSha256 = "sha256-1tR1vUm5eFBS93kELQoKWEyFlfMF28GBI8VEHxTyeM4=";

  ldflags = [ "-s" "-w" ];

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd fulcio \
      --bash <($out/bin/fulcio completion bash) \
      --fish <($out/bin/fulcio completion fish) \
      --zsh <($out/bin/fulcio completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/fulcio --help
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/fulcio";
    changelog = "https://github.com/sigstore/fulcio/releases/tag/${version}";
    description = "A Root-CA for code signing certs - issuing certificates based on an OIDC email address";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
