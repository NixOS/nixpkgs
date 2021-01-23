{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "1nmw1hkxgdp7nibrn1gz0lry0666rcc55s3kkfx64ykw6bnl0l34";
  };

  patches = [
    # fixes failing test, remove with next update
    # see https://github.com/xperimental/nextcloud-exporter/pull/25
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/xperimental/nextcloud-exporter/pull/25.patch";
      sha256 = "03jvqlqbs5g6ijncx6vxkgwq646yrjlrm0lk2q5vhfjrgrkv0alv";
      includes = [ "internal/config/config_test.go" ];
    })
  ];

  vendorSha256 = "0xdjphki0p03n6g5b4mm2x0rgm902rnbvq8r6p4r45k3mv8cggmf";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.unix;
  };
}
