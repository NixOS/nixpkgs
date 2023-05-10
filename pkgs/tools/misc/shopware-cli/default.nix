{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, dart-sass-embedded
}:

buildGoModule rec {
  pname = "shopware-cli";
  version = "0.1.62";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
    hash = "sha256-Vxg3hYUCN4UdBGHN57VXDlGdp+qzq8tbUDPAl/Bse44=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-O3dJX2w+J9TABkytaJ0ubFg9edVpmo7iPArc+Qqh3M4=";

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd shopware-cli \
      --bash <($out/bin/shopware-cli completion bash) \
      --zsh <($out/bin/shopware-cli completion zsh) \
      --fish <($out/bin/shopware-cli completion fish)
  '';

  preFixup = ''
    wrapProgram $out/bin/shopware-cli \
      --prefix PATH : ${lib.makeBinPath [ dart-sass-embedded ]}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/FriendsOfShopware/shopware-cli/cmd.version=${version}'"
  ];

  meta = with lib; {
    description = "Command line tool for Shopware 6";
    homepage = "https://github.com/FriendsOfShopware/shopware-cli";
    changelog = "https://github.com/FriendsOfShopware/shopware-cli/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
