{ lib, buildGoModule, fetchFromGitHub, brotli }:

buildGoModule rec {
  pname = "wal-g";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "0r6vy2b3xqwa22286srwngk63sq4aza6aj7brwc130vypcps7svp";
  };

  vendorSha256 = "0r73l4kxzldca1vg5mshq6iqsxcrndcbmbp3d7i9pxyb2kig8gv5";

  buildInputs = [ brotli ];

  subPackages = [ "main/pg" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version} -X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}" ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = with maintainers; [ ocharles marsam ];
  };
}
