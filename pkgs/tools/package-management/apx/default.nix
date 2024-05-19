{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  distrobox,
}:

buildGoModule rec {
  pname = "apx";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx";
    rev = "v${version}";
    hash = "sha256-X6nphUzJc/R3Egw09eRQbza1QebpLGsMIfV7BpLOXTc=";
  };

  vendorHash = "sha256-hGi+M5RRUL2oyxFGVeR0sum93/CA+FGYy0m4vDmlXTc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace config/apx.json \
      --replace-fail "/usr/share/apx/distrobox/distrobox" "${distrobox}/bin/distrobox" \
      --replace-fail "/usr/share/apx" "$out/bin/apx"
    substituteInPlace settings/config.go \
      --replace-fail "/usr/share/apx/" "$out/share/apx/"
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
