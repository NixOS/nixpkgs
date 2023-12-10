{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-JpLrCkPg0vVR0bKKHY5qf1/OD+O7yvWxS7kb7Yg3+c4=";
  };

  vendorHash = "sha256-uIilESEmAxANxFOy7qvYxlF/bId/Kqh4jUspNknlhlc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} *.md
  '';

  meta = with lib; {
    description = "ZFS Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/pdf/zfs_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
