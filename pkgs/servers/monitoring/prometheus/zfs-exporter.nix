{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-EM7CHvpqPwCKgb5QU+jYmMaovHp12hJD1zVxcYygHdU=";
  };

  vendorHash = "sha256-AgZo+5gYJ2EaxSI+Jxl7ldu6iZ+uSncYR0n+D2mMC4w=";

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
