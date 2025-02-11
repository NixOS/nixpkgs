{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-en30/vKZDlqRvQW3n5yeMwLrukObw0d+NfzmdWvfXZE=";
  };

  vendorHash = "sha256-fhodh5EcvAX2fruwv0e9VNAti2jKa7kEDQCVSDFl48A=";

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
