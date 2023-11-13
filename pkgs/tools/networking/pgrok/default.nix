{ lib
, buildGoModule
, callPackage
, fetchFromGitHub
}:
let
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "pgrok";
    repo = "pgrok";
    rev = "v${version}";
    hash = "sha256-2k3XLXmf1Xnx4HvS7sD/aq+78Z4I7uY4djV958n5TX4=";
  };
  web = callPackage ./web.nix { inherit src version; };
in
buildGoModule {
  pname = "pgrok";
  inherit version src;

  vendorHash = "sha256-M0xVHRh9NKPxmUEmx1dDQUZc8aXcdAfHisQAnt72RdY=";

  outputs = [ "out" "server" "web" ];

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
    cp -r ${web} $web
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Selfhosted TCP/HTTP tunnel, ngrok alternative, written in Go";
    homepage = "https://github.com/pgrok/pgrok";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
  };
}
