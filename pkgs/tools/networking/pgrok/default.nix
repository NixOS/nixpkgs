{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pgrok";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    rev = "v${version}";
    hash = "sha256-P36rpFi5J+dF6FrVaPhqupG00h4kwr0qumt4ehL/7vU=";
  };

  vendorHash = "sha256-X5FjzliIJdfJnNaUXBjv1uq5tyjMVjBbnLCBH/P0LFM=";

  outputs = [
    "out"
    "server"
  ];

  web = callPackage ./web.nix { inherit src version; };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=unknown"
    "-X main.date=unknown"
  ];

  subPackages = [
    "pgrok/pgrok"
    "pgrokd/pgrokd"
  ];

  postPatch = ''
    # rename packages due to naming conflict
    mv pgrok/cli/ pgrok/pgrok/
    mv pgrokd/cli/ pgrokd/pgrokd/
    cp -r ${web} pgrokd/pgrokd/dist
  '';

  postInstall = ''
    moveToOutput bin/pgrokd $server
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Selfhosted TCP/HTTP tunnel, ngrok alternative, written in Go";
    homepage = "https://github.com/pgrok/pgrok";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "pgrok";
  };
}
