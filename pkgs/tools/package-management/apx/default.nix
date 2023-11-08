{ lib
, buildGoModule
, fetchFromGitHub
, distrobox
}:

buildGoModule rec {
  pname = "apx";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3CelqEntpfld0n+Ewg7NCkowVjgCf5b6StfSkYbgV5k=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace config/apx.json \
      --replace "/usr/share/apx/distrobox" "${distrobox}/bin/distrobox" \
      --replace "/usr/share/apx" "$out/bin/apx"
    substituteInPlace settings/config.go \
      --replace "/usr/share/apx/" "$out/share/apx/"
  '';

  postInstall = ''
    install -D config/apx.json -t $out/share/apx/
    install -D man/man1/apx.1 -t $out/man/man1/
  '';

  meta = with lib; {
    description = "The Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya jgarcia ];
  };
}
