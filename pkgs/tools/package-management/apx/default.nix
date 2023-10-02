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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nBhSl4r7LlgCA5/HCLpOleihE5n/JCJgf43KdCklQbg=";
  };

  vendorHash = null;

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

    installManPage man/de/man1/apx.1 man/es/man1/apx.1 man/fr/man1/apx.1 man/it/man1/apx.1 man/man1/apx.1 man/nl/man1/apx.1 man/pl/man1/apx.1 man/pt/man1/apx.1 man/pt_BR/man1/apx.1 man/ro/man1/apx.1 man/ru/man1/apx.1 man/sv/man1/apx.1 man/tr/man1/apx.1
  '';

  meta = with lib; {
    description = "The Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
