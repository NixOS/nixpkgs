{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-NTlYMznUfDfLftvuR5YWOW4Zu0rWfLkKPHPTrD/62+Q=";
  };

  vendorHash = "sha256-ZJRxH9RhNSnVmcsonaakbvvjQ+3ovnyMny1Pe/vyQxE=";

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} *.md
  '';

  meta = with lib; {
    description = "ZFS Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/pdf/zfs_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
