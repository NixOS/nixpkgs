{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hostctl";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "guumaster";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rvUm31WRSLusM9VGsIHKGTH6Vs8LWPtzPDs3azA710w=";
  };

  vendorSha256 = "sha256-rGDWrivIdl5FTu/kNR8nAfE2+1hE4cm3uDg7oBobE9M=";

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
