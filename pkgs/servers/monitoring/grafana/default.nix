{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "8.0.0";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "sha256-HtubiSx4Orf9knZcuYy4eF2qwclX/JVd2Ba9L33tM74=";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "sha256-bwBpkPy4kwfnkRsLOktUgQx+Sm8WJA2d65efMBCnGp4=";
  };

  vendorSha256 = "sha256-Hon5WrhXUvZUtMRxx3XcBDQe3rkRkfqbnXjY3xCzuuM=";

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
  preBuild = ''
    rm -r scripts/go
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
