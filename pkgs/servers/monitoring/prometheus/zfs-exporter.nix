{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.3.10";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-8of1FdfofkmlTMSJKbpBxI5KNEu2y1Epkl2L6nNAJ/k=";
  };

  vendorHash = "sha256-wXPFR1B86oq/RieyYP1KTrpaUu3xOQnX2ismYt9N2Aw=";

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
    mainProgram = "zfs_exporter";
    homepage = "https://github.com/pdf/zfs_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
