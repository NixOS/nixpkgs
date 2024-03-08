{ lib
, buildGoModule
, fetchFromGitHub
, distrobox
, installShellFiles
}:

buildGoModule rec {
  pname = "apx";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx";
    rev = "v${version}";
    hash = "sha256-OLJrwibw9uX5ty7FRZ0q8zx0i1vQXRKK8reQsJFFxAI=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace config/apx.json \
      --replace "/usr/share/apx/distrobox/distrobox" "${distrobox}/bin/distrobox" \
      --replace "/usr/share/apx" "$out/bin/apx"
    substituteInPlace settings/config.go \
      --replace "/usr/share/apx/" "$out/share/apx/"
  '';

  postInstall = ''
    install -Dm444 config/apx.json -t $out/share/apx/
    installManPage man/man1/*
    install -Dm444 README.md -t $out/share/docs/apx
    install -Dm444 COPYING.md $out/share/licenses/apx/LICENSE
  '';

  meta = with lib; {
    description = "The Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya chewblacka ];
    mainProgram = "apx";
  };
}
