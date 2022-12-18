{ lib, buildGoModule, fetchFromGitHub, nixosTests }:
let
  pinData = lib.importJSON ./pin.json;
in
buildGoModule rec {
  pname = "mimir";
  version = pinData.version;

  src = fetchFromGitHub {
    rev = "${pname}-${version}";
    owner = "grafana";
    repo = pname;
    sha256 = pinData.sha256;
  };

  vendorSha256 = null;

  subPackages = [
    "cmd/mimir"
    "cmd/mimirtool"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) mimir;
    };
  };

  ldflags = let t = "github.com/grafana/mimir/pkg/util/version";
  in [
    ''-extldflags "-static"''
    "-s"
    "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=unknown"
    "-X ${t}.Branch=unknown"
  ];

  meta = with lib; {
    description =
      "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada bryanhonof ];
    platforms = platforms.unix;
  };
}
