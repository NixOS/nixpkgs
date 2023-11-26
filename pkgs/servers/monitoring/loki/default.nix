{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, systemd
}:

buildGoModule rec {
  version = "2.9.2";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    hash = "sha256-CYF0cse8NyHEnSZPRI9LNI09vr7kWPXHNibiEbW484E=";
  };

  vendorHash = null;

  subPackages = [
    # TODO split every executable into its own package
    "cmd/loki"
    "cmd/loki-canary"
    "clients/cmd/promtail"
    "cmd/logcli"
  ];

  tags = ["promtail_journal_enabled"];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isLinux [ systemd.dev ];

  preFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  passthru.tests = { inherit (nixosTests) loki; };

  ldflags = let t = "github.com/grafana/loki/pkg/util/build"; in [
    "-s"
    "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
    "-X ${t}.Branch=unknown"
    "-X ${t}.Revision=unknown"
  ];

  meta = with lib; {
    description = "Like Prometheus, but for logs";
    license = with licenses; [ agpl3Only asl20 ];
    homepage = "https://grafana.com/oss/loki/";
    changelog = "https://github.com/grafana/loki/releases/tag/v${version}";
    maintainers = with maintainers; [ willibutz globin mmahut emilylange ajs124 ];
  };
}
