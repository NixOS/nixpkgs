{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "coder";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d3Cg7G1rjxEqKMsIqxZ6ZZDEMIoisDtjZMmyixZRpF4=";
  };

  # integration tests require network access
  doCheck = false;

  vendorHash = "sha256-F9r99WhL1Uv5NNVlQYpQc282BAl8bUhJI5mZZYwyEEg=";

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
