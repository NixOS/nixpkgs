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

  preBuild = ''
    # The testcase makes an API call against grafana.com:
    #
    # --- Expected
    # +++ Actual
    # @@ -1,4 +1,4 @@
    #  (map[string]interface {}) (len=2) {
    # - (string) (len=5) "error": (string) (len=16) "plugin not found",
    # - (string) (len=7) "message": (string) (len=16) "Plugin not found"
    # + (string) (len=5) "error": (string) (len=171) "Failed to send request: Get \"https://grafana.com/api/plugins/repo/test\": dial tcp: lookup grafana.com on [::1]:53: read udp [::1]:48019->[::1]:53: read: connection refused",
    # + (string) (len=7) "message": (string) (len=24) "Failed to install plugin"
    #  }
    sed -ie '/func TestPluginInstallAccess/a t.Skip();' pkg/tests/api/plugins/api_install_test.go

    # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
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
    license = licenses.agpl3;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = platforms.linux;
  };
}
