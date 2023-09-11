{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "pgrok";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    rev = "v${version}";
    hash = "sha256-lhcaJVIqZK7GnC/Q/+RDxTVFmgTana3vugDHr/SStFE=";
  };
  vendorHash = "sha256-UzNx361cg4IDSQGlX5N9AxYZ8cYA0zsF5JF4Fe7efqM=";

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
