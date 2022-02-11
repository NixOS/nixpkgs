{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "hostctl";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "guumaster";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VjFjGvIoymGVVRiZUk/qoq/PTYoklp+Jz89zndX0e5A=";
  };

  vendorSha256 = "sha256-rGDWrivIdl5FTu/kNR8nAfE2+1hE4cm3uDg7oBobE9M=";

  ldflags = [ "-s" "-w" "-X github.com/guumaster/hostctl/cmd/hostctl/actions.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd hostctl \
      --bash <($out/bin/hostctl completion bash) \
      --zsh <($out/bin/hostctl completion zsh)
  '';

  meta = with lib; {
    description = "Your dev tool to manage /etc/hosts like a pro!";
    longDescription = ''
      This tool gives you more control over the use of your hosts file.
      You can have multiple profiles and switch them on/off as you need.
    '';
    homepage = "https://guumaster.github.io/hostctl/";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
