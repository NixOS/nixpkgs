{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "coder";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-85eH3gKn1khMiksA/kL+fHt1WiaOzVntYCiL1PR/0Cg=";
  };

  # integration tests require network access
  doCheck = false;

  vendorHash = "sha256-tdqqGM2b8un4BFtvRJsmiIGdb1AOKP8XxcgGg2DilXA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd coder \
      --bash <($out/bin/coder completion bash) \
      --fish <($out/bin/coder completion fish) \
      --zsh <($out/bin/coder completion zsh)
  '';

  meta = with lib; {
    description = "Provision software development environments via Terraform on Linux, macOS, Windows, X86, ARM, and of course, Kubernetes";
    homepage = "https://coder.com";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ghuntley urandom ];
  };
}
