{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "alertmanager-bot";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "metalmatze";
    repo = pname;
    rev = version;
    sha256 = "1hjfkksqb675gabzjc221b33h2m4s6qsanmkm382d3fyzqj71dh9";
  };

  vendorSha256 = null; #vendorSha256 = "";

  postPatch = ''
    sed "s;/templates/default.tmpl;$out/share&;" -i cmd/alertmanager-bot/main.go
  '';

  ldflags = [
    "-s" "-w" "-X main.Version=v${version}" "-X main.Revision=${src.rev}"
  ];

  postInstall = ''
    install -Dm644 -t $out/share/templates $src/default.tmpl
  '';

  meta = with lib; {
    description = "Bot for Prometheus' Alertmanager";
    homepage = "https://github.com/metalmatze/alertmanager-bot";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
  };
}
