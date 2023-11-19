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
