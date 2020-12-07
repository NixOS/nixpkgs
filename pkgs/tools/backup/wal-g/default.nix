{ lib, buildGoModule, fetchFromGitHub, brotli }:

buildGoModule rec {
  pname = "wal-g";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "030c949cs13x4gnby6apy1adis8d4dlg3gzhhhs991117dxb0i3v";
  };

  vendorSha256 = "186cqn10fljzjc876byaj1affd8xmi8zvmkfxp9dbzsfxdir4nf7";

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
    maintainers = with maintainers; [ marsam ];
  };
}
