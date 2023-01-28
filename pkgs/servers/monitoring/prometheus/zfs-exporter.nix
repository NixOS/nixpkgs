{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfs_exporter";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-FY3P2wmNWyr7mImc1PJs1G2Ae8rZvDzq0kRZfiRTzyc=";
  };

  vendorSha256 = "sha256-jQiw3HlqWcsjdadDdovCsDMBB3rnWtacfbtzDb5rc9c=";

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
