{ lib, buildGoModule, fetchFromGitHub, brotli }:

buildGoModule rec {
  pname = "wal-g";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "0pinvi2b3vi6lvw3im8w6vcjm1qg2kbf6ydf1h72xjz5933yrjy4";
  };

  vendorSha256 = "0qzw0lr0x6kqlpa4kghrfl2271752sr7idk6n4hkhk6q0kghcsnk";

  buildInputs = [ brotli ];

  subPackages = [ "main/pg" ];

  buildFlagsArray = [
    "-tags=brotli"
    "-ldflags=-s -w -X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version} -X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}"
  ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = with maintainers; [ marsam ];
  };
}
