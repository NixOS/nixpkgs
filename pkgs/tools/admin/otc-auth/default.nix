{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "otc-auth";
  version = "2.0.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "iits-consulting";
    repo = "otc-auth";
    hash = "sha256-dKBsceTv4SW3YWuVtC7U4u0IY9VZOrJ+QM5Jq+DW4Hw=";
  };
  vendorHash = "sha256-J2Xo5HCycc0FU5nMfa9eDwtL94fF4/4x4xxR+Fonk/E=";
  HOME = "/tmp";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd otc-auth \
        --bash <($out/bin/otc-auth completion bash) \
        --fish <($out/bin/otc-auth completion fish) \
        --zsh <($out/bin/otc-auth completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/iits-consulting/otc-auth";
    description = "Open Source CLI for the Open Telekom Cloud written in go.";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fabius ];
  };
}

