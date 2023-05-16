{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
<<<<<<< HEAD
, dart-sass
, git
=======
, dart-sass-embedded
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "shopware-cli";
<<<<<<< HEAD
  version = "0.2.8";
=======
  version = "0.1.62";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ThjSp7WBAWBUXDRN0mJvIb7uWTjYtVa53b+BoWCPuvo=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  nativeCheckInputs = [ git ];

  vendorHash = "sha256-JRzF2eYHnFO/2Tqnc4DMMGSV8gDKDiu8ZjELcn/Wur0=";
=======
    hash = "sha256-Vxg3hYUCN4UdBGHN57VXDlGdp+qzq8tbUDPAl/Bse44=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-O3dJX2w+J9TABkytaJ0ubFg9edVpmo7iPArc+Qqh3M4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd shopware-cli \
      --bash <($out/bin/shopware-cli completion bash) \
      --zsh <($out/bin/shopware-cli completion zsh) \
      --fish <($out/bin/shopware-cli completion fish)
  '';

  preFixup = ''
    wrapProgram $out/bin/shopware-cli \
<<<<<<< HEAD
      --prefix PATH : ${lib.makeBinPath [ dart-sass ]}
=======
      --prefix PATH : ${lib.makeBinPath [ dart-sass-embedded ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
