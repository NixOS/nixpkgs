{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "8.0.3";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "sha256-GGtmsz3c7Q6mEGCJ6cdz2CjOW0ovZZW8j6LMfFgrMZ4=";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "sha256-2x0FhKinrXAFenJcUDh4Q3RJNBrqixKBNZT7BZNNOj8=";
  };

  vendorSha256 = "sha256-x7sSVIim/TOhMTbnRK/fpgxiSRSO8KwGILTE2i1gU3U=";

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
    sed -i -e '/func TestPluginInstallAccess/a t.Skip();' pkg/tests/api/plugins/api_install_test.go

    # Skip a flaky test (https://github.com/NixOS/nixpkgs/pull/126928#issuecomment-861424128)
    sed -i -e '/it should change folder successfully and return correct result/{N;s/$/\nt.Skip();/}'\
      pkg/services/libraryelements/libraryelements_patch_test.go


    # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
    rm -r scripts/go
  '';

  buildFlagsArray = ''
    -ldflags=-s -w -X main.version=${version}
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
