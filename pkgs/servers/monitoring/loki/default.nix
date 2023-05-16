{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, systemd
}:

buildGoModule rec {
<<<<<<< HEAD
  version = "2.9.0";
=======
  version = "2.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B7LTwPTvRLHqY1du9kj5MKY1kJZT6maNsuc0PBwrMn8=";
=======
    hash = "sha256-29cpDLIwKw0CaYaNGv31E7sNTaRepymjvAZ8TL4RpxY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ willibutz globin mmahut emilylange ];
=======
    maintainers = with maintainers; [ willibutz globin mmahut indeednotjames ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
