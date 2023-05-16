{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, docker
, distrobox
}:

buildGoModule rec {
  pname = "apx";
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.7.0-1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-nBhSl4r7LlgCA5/HCLpOleihE5n/JCJgf43KdCklQbg=";
=======
    rev = "v${version}";
    hash = "sha256-tonI3S0a08MbR369qaKS2BoWc3QzXWzTuGx/zSgUz7s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    mkdir -p $out/etc/apx

    cat > "$out/etc/apx/config.json" <<EOF
    {
      "containername": "apx_managed",
      "image": "docker.io/library/ubuntu",
      "pkgmanager": "apt",
      "distroboxpath": "${distrobox}/bin/distrobox"
    }
    EOF

    wrapProgram $out/bin/apx --prefix PATH : ${lib.makeBinPath [ docker distrobox ]}

<<<<<<< HEAD
    installManPage man/de/man1/apx.1 man/es/man1/apx.1 man/fr/man1/apx.1 man/it/man1/apx.1 man/man1/apx.1 man/nl/man1/apx.1 man/pl/man1/apx.1 man/pt/man1/apx.1 man/pt_BR/man1/apx.1 man/ro/man1/apx.1 man/ru/man1/apx.1 man/sv/man1/apx.1 man/tr/man1/apx.1
=======
    installManPage man/apx.1 man/es/apx.1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "The Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
<<<<<<< HEAD
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/${version}";
    license = licenses.gpl3Only;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ dit7ya ];
  };
}
