{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
}:
buildGoModule rec {
  pname = "coder";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S+s6cOO2iISW3x+JM6mkpAC6KJv/x84RgXuaiFHZs+I=";
  };

  # integration tests require network access
  doCheck = false;

  vendorHash = "sha256-nqmwwdIOm6jTPTAuvIqPf0xgVgIbKsUIs0Mbfka0jyU=";

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
