{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "pgrok";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    rev = "v${version}";
    hash = "sha256-0b7d3wyhRuTxZmpx9oJnZN88yYn+TsR82KrktPAx9P4=";
  };
  vendorHash = "sha256-laSfyHFkJJkv4EPMIVcai7RXaGIpUp+0tOpt5vhcLkA=";

  outputs = [ "out" "server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=unknown"
    "-X main.date=unknown"
  ];

  postInstall = ''
    moveToOutput bin/pgrokd $server
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Selfhosted TCP/HTTP tunnel, ngrok alternative, written in Go";
    homepage = "https://github.com/pgrok/pgrok";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
  };
}
