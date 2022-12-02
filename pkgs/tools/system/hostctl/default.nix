{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hostctl";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "guumaster";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3CfUU74e79eilu7WP+EeoGlXUYnxmRpjb8RaH/XXjxo=";
  };

  vendorSha256 = "sha256-3UM9w3o3qSlUvgg0k87aODJXqx1ryFvxHs6hlovBILY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/guumaster/hostctl/cmd/hostctl/actions.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd hostctl \
      --bash <($out/bin/hostctl completion bash) \
      --zsh <($out/bin/hostctl completion zsh)
  '';

  meta = with lib; {
    description = "CLI tool to manage the /etc/hosts file";
    longDescription = ''
      This tool gives you more control over the use of your hosts file.
      You can have multiple profiles and switch them on/off as you need.
    '';
    homepage = "https://guumaster.github.io/hostctl/";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
