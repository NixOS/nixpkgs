{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "18xvxx0aplkj7xzi0zfsz7a5d45hh8blfqb105360pknvvi6apjv";
  };

  vendorSha256 = "1wr1ckz0klk9sqpyk96h8bwr1dg6aiirr1l1f23kbib91pfpd08r";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
    platforms = platforms.unix;
  };
}
