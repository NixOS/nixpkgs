{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, systemd
}:

buildGoModule rec {
  version = "2.4.2";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "sha256-HSEdN3PN4wQQ3A7bICNIAgdwhwD/PIUeOdW9ZgwmbCw=";
  };

  vendorSha256 = null;

  subPackages = [
    # TODO split every executable into its own package
    "cmd/loki"
    "cmd/loki-canary"
    "clients/cmd/promtail"
    "cmd/logcli"
  ];

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

  doCheck = true;

  meta = with lib; {
    description = "Like Prometheus, but for logs";
    license = with licenses; [ agpl3Only asl20 ];
    homepage = "https://grafana.com/oss/loki/";
    maintainers = with maintainers; [ willibutz globin mmahut ];
    platforms = platforms.unix;
  };
}
