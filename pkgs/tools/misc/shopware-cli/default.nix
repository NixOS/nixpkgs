{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, dart-sass
}:

buildGoModule rec {
  pname = "shopware-cli";
  version = "0.2.1";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
    hash = "sha256-3upZmqsKCg98j/HTwFp0L7MMspCw7Dj6dRoyEPW287k=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorHash = "sha256-KEWACwZka4WMQS4/O6WkIdeeUnxtcpEwQmMlNBLUjbI=";

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd shopware-cli \
      --bash <($out/bin/shopware-cli completion bash) \
      --zsh <($out/bin/shopware-cli completion zsh) \
      --fish <($out/bin/shopware-cli completion fish)
  '';

  preFixup = ''
    wrapProgram $out/bin/shopware-cli \
      --prefix PATH : ${lib.makeBinPath [ dart-sass ]}
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
