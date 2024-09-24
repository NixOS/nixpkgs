{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, systemd
, testers
, grafana-loki
}:

buildGoModule rec {
  version = "3.2.0";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    hash = "sha256-dche8MbVSlwKMD/znOCj80FNf5KZmEuI3uodrFLrmjM=";
  };

  vendorHash = null;

  subPackages = [
    # TODO split every executable into its own package
    "cmd/loki"
    "cmd/loki-canary"
    "clients/cmd/promtail"
    "cmd/logcli"
    "cmd/lokitool"
  ];

  tags = ["promtail_journal_enabled"];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ systemd.dev ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  passthru.tests = {
    inherit (nixosTests) loki;
    version = testers.testVersion {
      command = "loki --version";
      package = grafana-loki;
    };
  };

  ldflags = let t = "github.com/grafana/loki/v3/pkg/util/build"; in [
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
    mainProgram = "promtail";
    license = with licenses; [ agpl3Only asl20 ];
    homepage = "https://grafana.com/oss/loki/";
    changelog = "https://github.com/grafana/loki/releases/tag/v${version}";
    maintainers = with maintainers; [ willibutz globin mmahut emilylange ] ++ teams.helsinki-systems.members;
  };
}
