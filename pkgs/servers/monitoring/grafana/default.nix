{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.5.7";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "sha256-GTQK02zxOBTE+93vT0zLMhAeZ7F3Cq/0lbvbzwB2QZA=";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "sha256-IQ7aAuUrNa+bSh5ld6IttujM8AgKUSlu8H7pwzDi164=";
  };

  vendorSha256 = "sha256-AsPRaRLomp090XAKLXLXKm40ESPO4im9qi6VLpLYRQU=";

  # grafana-aws-sdk is specified with two versions which causes a problem later:
  # go: inconsistent vendoring in /build/source:
  #  github.com/grafana/grafana-aws-sdk@v0.3.0: is explicitly required in go.mod, but not marked as explicit in vendor/modules.txt
  # Remove the older one here to fix this.
  postPatch = ''
    substituteInPlace go.mod \
      --replace 'github.com/grafana/grafana-aws-sdk v0.3.0' ""

    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
  # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/dashboard-schemas
  preBuild = ''
    rm -r dashboard-schemas scripts/go
  '';

  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $out/share/grafana
    mv grafana-*/{public,conf,tools} $out/share/grafana/
  '';

  passthru.tests = { inherit (nixosTests) grafana; };

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = platforms.linux;
  };
}
